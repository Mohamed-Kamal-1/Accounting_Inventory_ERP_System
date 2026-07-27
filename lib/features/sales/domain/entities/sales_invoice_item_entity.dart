import 'package:equatable/equatable.dart';

class SaleInvoiceItemEntity extends Equatable {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double itemDiscountPercent;
  final double total;

  const SaleInvoiceItemEntity({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.itemDiscountPercent,
    required this.total,
  });

  @override
  List<Object?> get props => [productId, quantity, total];
}
