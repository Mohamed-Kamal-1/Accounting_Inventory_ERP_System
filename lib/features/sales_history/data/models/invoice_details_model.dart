import '../../domain/entities/invoice_details_entity.dart';

class InvoiceDetailsModel extends InvoiceDetailsEntity {
  const InvoiceDetailsModel({
    required super.itemId,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
  });

  factory InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return InvoiceDetailsModel(
      itemId: json['item_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? 'صنف غير معروف',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      unitPrice: parseDouble(json['unit_price']),
      totalPrice: parseDouble(json['total_price']),
    );
  }
}
