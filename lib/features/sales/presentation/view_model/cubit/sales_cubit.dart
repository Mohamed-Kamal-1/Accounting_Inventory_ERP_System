import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../contacts/domain/entities/contact_entity.dart'; // تأكد من المسار
import '../../../../contacts/domain/repositories/contacts_repository.dart'; // تأكد من المسار
import '../../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../domain/entities/sale_invoice_entity.dart';
import '../../../domain/entities/sales_invoice_item_entity.dart';
import 'sales_invoice_state.dart';

@injectable
class SalesCubit extends Cubit<SalesState> {
  final InventoryRepository _inventoryRepository;
  final ContactsRepository _contactsRepository; // 1. حقن الريبوزيتوري

  List<ContactEntity> _allContacts = []; // قائمة بالكاش

  SalesCubit(this._inventoryRepository, this._contactsRepository)
      : super(const SalesState());

  // دالة مجمعة للتهيئة
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

  // جلب جهات الاتصال
  Future<void> fetchContacts() async {
    final result = await _contactsRepository.getContacts();
    result.fold(
      onFailure: (failure) {
        // يمكن إضافة معالجة للخطأ هنا
      },
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
      selectedContactId: '', // تصفير العميل عند تغيير النوع
    ));
    _filterContactsByMode(mode);
  }

  void _filterContactsByMode(String mode) {
    List<ContactEntity> filtered = [];
    if (mode == 'merchant') {
      filtered = _allContacts.where((c) => c.type == 'merchant').toList();
    } else if (mode == 'salesman') {
      filtered = _allContacts.where((c) => c.type == 'sales').toList();
    } else if (mode == 'supplier') {
      filtered = _allContacts.where((c) => c.type == 'supplier').toList();
    }
    emit(state.copyWith(filteredContacts: filtered));
  }

  void updateSelectedContact(String contactId) {
    emit(state.copyWith(selectedContactId: contactId));
  }

  // باقي الدوال (addItemToCart, removeItemFromCart, updateDiscount, updatePaidAmount, _calculateTotals) كما هي تماماً بدون تغيير...
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

  Future<void> submitInvoice(
      {required String contactId,
      required String contactName,
      required String city}) async {
    if (state.cart.isEmpty) {
      emit(state.copyWith(submitError: 'السلة فارغة. يرجى إضافة أصناف.'));
      emit(state.copyWith(submitError: ''));
      return;
    }

    emit(state.copyWith(isSubmitting: true, submitError: ''));

    // نستخدم ID العميل من הـ state الذي تم تحديثه عبر الـ Autocomplete
    final finalContactId = state.selectedContactId.isNotEmpty
        ? state.selectedContactId
        : (contactId.isEmpty ? 'dummy_id' : contactId);

    final invoice = SaleInvoiceEntity(
      contactId: finalContactId,
      contactName: contactName,
      mode: state.currentMode,
      date: DateTime.now(),
      city: city,
      lineName: '',
      items: state.cart,
      subTotal: state.subTotal,
      invoiceDiscountPercent: state.invoiceDiscountPercent,
      grandTotal: state.grandTotal,
      paidAmount: state.paidAmount,
      remainingAmount: state.remainingAmount,
    );

    try {
      await Future.delayed(const Duration(seconds: 1));
      _handleSuccess();
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false, submitError: 'حدث خطأ غير متوقع أثناء الحفظ'));
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
