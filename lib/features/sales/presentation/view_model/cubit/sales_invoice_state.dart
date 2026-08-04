import 'package:equatable/equatable.dart';

import '../../../../contacts/domain/entities/contact_entity.dart'; // تأكد من المسار
import '../../../../inventory/domain/entities/product_entity.dart';
import '../../../domain/entities/sales_invoice_item_entity.dart';

class SalesState extends Equatable {
  final String currentMode;
  final List<SaleInvoiceItemEntity> cart;
  final double subTotal;
  final double invoiceDiscountPercent;
  final double grandTotal;
  final double paidAmount;
  final double remainingAmount;
  final List<ProductEntity> availableProducts;
  final bool isLoadingProducts;
  final String productsError;
  final bool isSubmitting;
  final String submitError;
  final bool isSuccess;

  // المتغيرات الجديدة للعملاء
  final List<ContactEntity> filteredContacts;
  final String selectedContactId;

  const SalesState({
    this.currentMode = 'merchant',
    this.cart = const [],
    this.subTotal = 0.0,
    this.invoiceDiscountPercent = 0.0,
    this.grandTotal = 0.0,
    this.paidAmount = 0.0,
    this.remainingAmount = 0.0,
    this.availableProducts = const [],
    this.isLoadingProducts = false,
    this.productsError = '',
    this.isSubmitting = false,
    this.submitError = '',
    this.isSuccess = false,
    this.filteredContacts = const [],
    this.selectedContactId = '',
  });

  SalesState copyWith({
    String? currentMode,
    List<SaleInvoiceItemEntity>? cart,
    double? subTotal,
    double? invoiceDiscountPercent,
    double? grandTotal,
    double? paidAmount,
    double? remainingAmount,
    List<ProductEntity>? availableProducts,
    bool? isLoadingProducts,
    String? productsError,
    bool? isSubmitting,
    String? submitError,
    bool? isSuccess,
    List<ContactEntity>? filteredContacts,
    String? selectedContactId,
  }) {
    return SalesState(
      currentMode: currentMode ?? this.currentMode,
      cart: cart ?? this.cart,
      subTotal: subTotal ?? this.subTotal,
      invoiceDiscountPercent:
          invoiceDiscountPercent ?? this.invoiceDiscountPercent,
      grandTotal: grandTotal ?? this.grandTotal,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      availableProducts: availableProducts ?? this.availableProducts,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      productsError: productsError ?? this.productsError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError ?? this.submitError,
      isSuccess: isSuccess ?? false,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      selectedContactId: selectedContactId ?? this.selectedContactId,
    );
  }

  @override
  List<Object?> get props => [
        currentMode,
        cart,
        subTotal,
        invoiceDiscountPercent,
        grandTotal,
        paidAmount,
        remainingAmount,
        availableProducts,
        isLoadingProducts,
        productsError,
        isSubmitting,
        submitError,
        isSuccess,
        filteredContacts,
        selectedContactId,
      ];
}
