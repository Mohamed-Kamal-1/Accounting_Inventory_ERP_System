import 'package:accounting_desktop/features/sales/presentation/view_model/cubit/sales_invoice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../domain/entities/sale_invoice_entity.dart';
import '../../../domain/entities/sales_invoice_item_entity.dart';

@injectable
class SalesCubit extends Cubit<SalesState> {
  final InventoryRepository _inventoryRepository;

  SalesCubit(this._inventoryRepository) : super(const SalesState());

  // 1. جلب المنتجات
  Future<void> fetchProducts() async {
    emit(state.copyWith(isLoadingProducts: true, productsError: ''));

    final result = await _inventoryRepository.getProducts();

    result.fold(
      onFailure: (failure) {
        emit(state.copyWith(
          isLoadingProducts: false,
          productsError: failure.message,
        ));
      },
      onSuccess: (products) {
        emit(state.copyWith(
          isLoadingProducts: false,
          availableProducts: products,
        ));
      },
    );
  }

  // 2. تغيير التبويب
  void changeMode(String mode) {
    emit(state.copyWith(
      currentMode: mode,
      cart: [], // تفريغ السلة منطقياً عند تغيير نوع المعاملة
      subTotal: 0.0,
      grandTotal: 0.0,
      remainingAmount: 0.0,
    ));
  }

  // 3. إضافة صنف للجدول
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

  // 4. إزالة صنف من الجدول
  void removeItemFromCart(int index) {
    final List<SaleInvoiceItemEntity> currentCart = List.from(state.cart);
    currentCart.removeAt(index);
    _calculateTotals(newCart: currentCart);
  }

  // 5. تحديث نسبة الخصم
  void updateDiscount(double discount) {
    _calculateTotals(newDiscount: discount);
  }

  // 6. تحديث المبلغ المدفوع
  void updatePaidAmount(double paidAmount) {
    _calculateTotals(newPaidAmount: paidAmount);
  }

  // حساب الإجماليات
  void _calculateTotals({
    List<SaleInvoiceItemEntity>? newCart,
    double? newDiscount,
    double? newPaidAmount,
  }) {
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

  // 7. حفظ الفاتورة
  Future<void> submitInvoice({
    required String contactId,
    required String contactName,
    required String city,
  }) async {
    if (state.cart.isEmpty) {
      emit(state.copyWith(submitError: 'السلة فارغة. يرجى إضافة أصناف.'));
      // إعادة تصفير الخطأ حتى لا يعلق
      emit(state.copyWith(submitError: ''));
      return;
    }

    emit(state.copyWith(isSubmitting: true, submitError: ''));

    final invoice = SaleInvoiceEntity(
      contactId: contactId.isEmpty ? 'dummy_id' : contactId,
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
      // محاكاة الإرسال لقاعدة البيانات (استبدلها لاحقاً بالـ UseCase الخاص بك)
      await Future.delayed(const Duration(seconds: 1));

      _handleSuccess();
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false, submitError: 'حدث خطأ غير متوقع أثناء الحفظ'));
    }
  }

  // تفريغ الفاتورة بعد النجاح
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
    ));

    // إعادة الـ isSuccess إلى false حتى لا تظهر رسالة النجاح مراراً
    emit(state.copyWith(isSuccess: false));
  }
}
