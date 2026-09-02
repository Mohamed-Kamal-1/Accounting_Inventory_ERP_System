class PurchaseItemEntity {
  final String productId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const PurchaseItemEntity({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}

class PurchaseInvoiceEntity {
  final String contactId;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final double paidAmount;
  final double remainingAmount;
  final String status;
  final List<PurchaseItemEntity> items;

  const PurchaseInvoiceEntity({
    required this.contactId,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.items,
  });
}
