class PurchasesHistoryItemEntity {
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const PurchasesHistoryItemEntity({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}

class PurchasesHistoryEntity {
  final String id;
  final String createdAt;
  final String supplierName;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final double paidAmount;
  final double remainingAmount;
  final String status;
  final List<PurchasesHistoryItemEntity> items;

  const PurchasesHistoryEntity({
    required this.id,
    required this.createdAt,
    required this.supplierName,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.items,
  });
}
