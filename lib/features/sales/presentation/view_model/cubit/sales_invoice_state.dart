import 'package:equatable/equatable.dart';

import '../../../../inventory/domain/entities/product_entity.dart';
import '../../../domain/entities/sale_invoice_entity.dart';

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
      ];
}
