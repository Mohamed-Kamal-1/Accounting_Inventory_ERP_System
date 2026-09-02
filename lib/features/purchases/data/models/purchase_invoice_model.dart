import '../../domain/entities/purchase_invoice_entity.dart';

class PurchaseItemModel extends PurchaseItemEntity {
  const PurchaseItemModel({
    required super.productId,
    required super.name,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
  });

  factory PurchaseItemModel.fromEntity(PurchaseItemEntity entity) {
    return PurchaseItemModel(
      productId: entity.productId,
      name: entity.name,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}

class PurchaseInvoiceModel extends PurchaseInvoiceEntity {
  const PurchaseInvoiceModel({
    required super.contactId,
    required super.subTotal,
    required super.discount,
    required super.grandTotal,
    required super.paidAmount,
    required super.remainingAmount,
    required super.status,
    required super.items,
  });

  factory PurchaseInvoiceModel.fromEntity(PurchaseInvoiceEntity entity) {
    return PurchaseInvoiceModel(
      contactId: entity.contactId,
      subTotal: entity.subTotal,
      discount: entity.discount,
      grandTotal: entity.grandTotal,
      paidAmount: entity.paidAmount,
      remainingAmount: entity.remainingAmount,
      status: entity.status,
      items: entity.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'sub_total': subTotal,
      'discount': discount,
      'grand_total': grandTotal,
      'total_amount': grandTotal,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'status': status,
    };
  }
}
