import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/di/di.dart';
import '../../../../contacts/domain/entities/contact_entity.dart';
import '../../../../contacts/domain/repositories/contacts_repository.dart';
import '../../../../inventory/domain/entities/product_entity.dart';
import '../../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../domain/entities/sales_invoice_item_entity.dart';
import 'sales_invoice_state.dart';

@injectable
class SalesCubit extends Cubit<SalesState> {
  Map<String, dynamic>? lastSavedInvoiceData;
  final InventoryRepository _inventoryRepository;
  final ContactsRepository _contactsRepository;

  List<ContactEntity> _allContacts = [];
  DateTime? _lastContactsFetch;

  SalesCubit(this._inventoryRepository, this._contactsRepository)
      : super(const SalesState());

  Future<void> initData() async {
    await fetchProducts();
    await fetchContacts();
  }

  Future<void> fetchProducts() async {
    emit(state.copyWith(isLoadingProducts: true, productsError: ''));
    final result = await _inventoryRepository.getProducts();
    result.fold(
      onFailure: (failure) => emit(state.copyWith(
          isLoadingProducts: false, productsError: failure.message)),
      onSuccess: (products) => emit(state.copyWith(
          isLoadingProducts: false, availableProducts: products)),
    );
  }

  Future<void> fetchContacts({bool force = false}) async {
    if (!force && _lastContactsFetch != null) {
      final difference =
          DateTime.now().difference(_lastContactsFetch!).inSeconds;
      if (difference < 15) {
        debugPrint('تم حظر الطلب: البيانات محدثة مسبقاً منذ $difference ثانية');
        return;
      }
    }

    final result = await _contactsRepository.getContacts();
    result.fold(
      onFailure: (failure) {},
      onSuccess: (contacts) {
        _allContacts = contacts;
        _lastContactsFetch = DateTime.now();
        _filterContactsByMode(state.currentMode);
      },
    );
  }

  void changeMode(String mode) {
    emit(state.copyWith(
      currentMode: mode,
      cart: [],
      subTotal: 0.0,
      grandTotal: 0.0,
      remainingAmount: 0.0,
      selectedContactId: '',
    ));
    _filterContactsByMode(mode);
  }

  void _filterContactsByMode(String mode) {
    List<ContactEntity> filtered = [];
    if (mode == 'merchant') {
      filtered = _allContacts.where((c) {
        final t = c.type.trim().toLowerCase();
        return t.contains('تاجر') ||
            t.contains('عميل') ||
            t.contains('merchant') ||
            t.contains('client');
      }).toList();
    } else if (mode == 'salesman') {
      filtered = _allContacts.where((c) {
        final t = c.type.trim().toLowerCase();
        return t.contains('مندوب') || t.contains('sales');
      }).toList();
    } else if (mode == 'supplier') {
      filtered = _allContacts.where((c) {
        final t = c.type.trim().toLowerCase();
        return t.contains('مورد') || t.contains('supplier');
      }).toList();
    }
    emit(state.copyWith(filteredContacts: filtered));
  }

  void updateSelectedContact(String contactId) {
    emit(state.copyWith(selectedContactId: contactId));
  }

  void addItemToCart(String pId, String pName, double price, int qty) {
    if (qty <= 0) {
      emit(state.copyWith(submitError: 'لا يمكن بيع كمية تساوي صفر أو أقل.'));
      emit(state.copyWith(submitError: ''));
      return;
    }
    if (price <= 0) {
      emit(state.copyWith(submitError: 'سعر الصنف غير صالح.'));
      emit(state.copyWith(submitError: ''));
      return;
    }

    final product = state.availableProducts.firstWhere(
      (p) => p.id == pId,
      orElse: () => throw Exception('الصنف غير موجود'),
    );

    final List<SaleInvoiceItemEntity> currentCart = List.from(state.cart);
    final existingIndex =
        currentCart.indexWhere((item) => item.productId == pId);

    final currentCartQty =
        existingIndex >= 0 ? currentCart[existingIndex].quantity : 0;
    final totalRequestedQty = currentCartQty + qty;

    if (totalRequestedQty > product.currentQuantity) {
      emit(state.copyWith(
          submitError:
              'فشل: الكمية المطلوبة ($totalRequestedQty) تتجاوز الرصيد المتاح في المخزن (${product.currentQuantity}).'));
      emit(state.copyWith(submitError: ''));
      return;
    }

    if (existingIndex >= 0) {
      currentCart[existingIndex] = SaleInvoiceItemEntity(
        productId: pId,
        productName: pName,
        unitPrice: price,
        quantity: totalRequestedQty,
        itemDiscountPercent: 0,
        total: price * totalRequestedQty,
      );
    } else {
      currentCart.add(SaleInvoiceItemEntity(
        productId: pId,
        productName: pName,
        unitPrice: price,
        quantity: qty,
        itemDiscountPercent: 0,
        total: price * qty,
      ));
    }
    _calculateTotals(newCart: currentCart);
  }

  // ⚠️ هذه الدالة تم حذفها منك بالخطأ وأعدتها لك
  void removeItemFromCart(int index) {
    final List<SaleInvoiceItemEntity> currentCart = List.from(state.cart);
    currentCart.removeAt(index);
    _calculateTotals(newCart: currentCart);
  }

  // ⚠️ وهذه دالة الخصم أعدتها لك أيضاً
  void updateDiscount(double discount) {
    double validDiscount = discount;
    if (validDiscount < 0) validDiscount = 0;
    if (validDiscount > 100) validDiscount = 100; // منع الخصم أكثر من 100%
    _calculateTotals(newDiscount: validDiscount);
  }

  void updatePaidAmount(double paidAmount) {
    double validPaid = paidAmount;
    if (validPaid < 0) validPaid = 0;
    _calculateTotals(newPaidAmount: validPaid);
  }

  void _calculateTotals(
      {List<SaleInvoiceItemEntity>? newCart,
      double? newDiscount,
      double? newPaidAmount}) {
    final cart = newCart ?? state.cart;
    final discount = newDiscount ?? state.invoiceDiscountPercent;
    double paid = newPaidAmount ?? state.paidAmount;

    final subTotal = cart.fold(0.0, (sum, item) => sum + item.total);
    final grandTotal = subTotal - (subTotal * (discount / 100));

    if (paid > grandTotal) {
      paid = grandTotal;
    }

    final remainingAmount = grandTotal - paid;

    emit(state.copyWith(
      cart: cart,
      invoiceDiscountPercent: discount,
      paidAmount: paid,
      subTotal: subTotal,
      grandTotal: grandTotal,
      remainingAmount: remainingAmount,
    ));
  }

  Future<void> submitInvoice({
    required String contactId,
    required String contactName,
    required String city,
  }) async {
    if (state.cart.isEmpty) {
      emit(state.copyWith(submitError: 'السلة فارغة. يرجى إضافة أصناف.'));
      emit(state.copyWith(submitError: ''));
      return;
    }

    final finalContactId = state.selectedContactId;
    if (finalContactId.isEmpty) {
      emit(state.copyWith(
          submitError: 'يرجى اختيار جهة اتصال صحيحة من القائمة.'));
      emit(state.copyWith(submitError: ''));
      return;
    }

    emit(state.copyWith(isSubmitting: true, submitError: ''));

    try {
      final itemsJson = state.cart
          .map((item) => {
                'product_id': item.productId,
                'quantity': item.quantity,
                'unit_price': item.unitPrice,
              })
          .toList();

      // 1. نضرب السيرفر أولاً وننتظر الرد
      await getIt.get<SupabaseClient>().rpc(
        'process_sales_invoice',
        params: {
          'p_contact_id': finalContactId,
          'p_mode': state.currentMode,
          'p_sub_total': state.subTotal,
          'p_discount': state.invoiceDiscountPercent,
          'p_grand_total': state.grandTotal,
          'p_paid_amount': state.paidAmount,
          'p_remaining_amount': state.remainingAmount,
          'p_items': itemsJson,
        },
      );

      // 2. إذا وصلنا لهذا السطر، يعني أن قاعدة البيانات حفظت الفاتورة بنجاح.
      // الآن فقط نسمح بتخزينها في الذاكرة لطباعتها لاحقاً.
      lastSavedInvoiceData = {
        'contactName': contactName,
        'currentMode': state.currentMode,
        'cart': List<SaleInvoiceItemEntity>.from(state.cart),
        'subTotal': state.subTotal,
        'discount': state.invoiceDiscountPercent,
        'grandTotal': state.grandTotal,
        'paidAmount': state.paidAmount,
        'remainingAmount': state.remainingAmount,
      };

      // 3. ننهي العملية بنجاح لتحديث الواجهة
      _handleSuccess();
    } catch (e) {
      debugPrint('Invoice Submit Error: $e');
      emit(state.copyWith(
          isSubmitting: false,
          submitError:
              'فشل حفظ الفاتورة: تأكد من صحة البيانات أو اتصال الإنترنت'));
    }
  }

  void _handleSuccess() {
    final updatedProducts = state.availableProducts.map((product) {
      final soldItem =
          state.cart.where((item) => item.productId == product.id).firstOrNull;
      if (soldItem != null) {
        return ProductEntity(
          id: product.id,
          categoryId: product.categoryId,
          name: product.name,
          purchasePrice: product.purchasePrice,
          salePrice: product.salePrice,
          surveyPrice: product.surveyPrice,
          minQty: product.minQty,
          showToSurvey: product.showToSurvey,
          currentQuantity: product.currentQuantity - soldItem.quantity,
        );
      }
      return product;
    }).toList();

    emit(state.copyWith(
      isSubmitting: false,
      isSuccess: true,
      availableProducts: updatedProducts,
      // ⚠️ أزلنا مسح البيانات من هنا لكي تلتقطها شاشة الطباعة أولاً
    ));

    emit(state.copyWith(isSuccess: false));
  }

  // دالة جديدة سيتم استدعاؤها من الواجهة بعد التقاط الفاتورة
  void resetCart() {
    emit(state.copyWith(
      cart: const [],
      subTotal: 0.0,
      grandTotal: 0.0,
      remainingAmount: 0.0,
      paidAmount: 0.0,
      invoiceDiscountPercent: 0.0,
      selectedContactId: '',
    ));
  }
}
