import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/di/di.dart';
import '../../../../contacts/domain/entities/contact_entity.dart';
import '../../../../contacts/domain/repositories/contacts_repository.dart';
import '../../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../domain/entities/sales_invoice_item_entity.dart';
import 'sales_invoice_state.dart';

@injectable
class SalesCubit extends Cubit<SalesState> {
  final InventoryRepository _inventoryRepository;
  final ContactsRepository _contactsRepository;

  List<ContactEntity> _allContacts = [];

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

  Future<void> fetchContacts() async {
    final result = await _contactsRepository.getContacts();
    result.fold(
      onFailure: (failure) {},
      onSuccess: (contacts) {
        _allContacts = contacts;
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
        return t == 'merchant' || t == 'تاجر' || t == 'عميل' || t == 'client';
      }).toList();
    } else if (mode == 'salesman') {
      filtered = _allContacts.where((c) {
        final t = c.type.trim().toLowerCase();
        return t == 'sales  ' || t == 'salesman' || t == 'مندوب';
      }).toList();
    } else if (mode == 'supplier') {
      filtered = _allContacts.where((c) {
        final t = c.type.trim().toLowerCase();
        return t == 'supplier' || t == 'مورد';
      }).toList();
    }
    emit(state.copyWith(filteredContacts: filtered));
  }

  void updateSelectedContact(String contactId) {
    emit(state.copyWith(selectedContactId: contactId));
  }

  void addItemToCart(String pId, String pName, double price, int qty) {
    final List<SaleInvoiceItemEntity> currentCart = List.from(state.cart);
    final existingIndex =
        currentCart.indexWhere((item) => item.productId == pId);

    if (existingIndex >= 0) {
      final existingItem = currentCart[existingIndex];
      final newQty = existingItem.quantity + qty;
      currentCart[existingIndex] = SaleInvoiceItemEntity(
        productId: pId,
        productName: pName,
        unitPrice: price,
        quantity: newQty,
        itemDiscountPercent: 0,
        total: price * newQty,
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

  void removeItemFromCart(int index) {
    final List<SaleInvoiceItemEntity> currentCart = List.from(state.cart);
    currentCart.removeAt(index);
    _calculateTotals(newCart: currentCart);
  }

  void updateDiscount(double discount) =>
      _calculateTotals(newDiscount: discount);

  void updatePaidAmount(double paidAmount) =>
      _calculateTotals(newPaidAmount: paidAmount);

  void _calculateTotals(
      {List<SaleInvoiceItemEntity>? newCart,
      double? newDiscount,
      double? newPaidAmount}) {
    final cart = newCart ?? state.cart;
    final discount = newDiscount ?? state.invoiceDiscountPercent;
    final paid = newPaidAmount ?? state.paidAmount;
    final subTotal = cart.fold(0.0, (sum, item) => sum + item.total);
    final grandTotal = subTotal - (subTotal * (discount / 100));
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
    emit(state.copyWith(
      isSubmitting: false,
      isSuccess: true,
      cart: const [],
      subTotal: 0.0,
      grandTotal: 0.0,
      remainingAmount: 0.0,
      paidAmount: 0.0,
      invoiceDiscountPercent: 0.0,
      selectedContactId: '',
    ));
    emit(state.copyWith(isSuccess: false));
  }
}
