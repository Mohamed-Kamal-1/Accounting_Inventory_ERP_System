import 'package:equatable/equatable.dart';

class InvoiceDetailsEntity extends Equatable {
  final String itemId;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const InvoiceDetailsEntity({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        itemId,
        productId,
        productName,
        quantity,
        unitPrice,
        totalPrice,
      ];
}
