import '../../domain/entities/purchases_history_entity.dart';

class PurchasesHistoryModel extends PurchasesHistoryEntity {
  const PurchasesHistoryModel({
    required super.id,
    required super.createdAt,
    required super.supplierName,
    required super.subTotal,
    required super.discount,
    required super.grandTotal,
    required super.paidAmount,
    required super.remainingAmount,
    required super.status,
    required super.items,
  });

  factory PurchasesHistoryModel.fromJson(
      Map<String, dynamic> json, List<Map<String, dynamic>> itemsJson) {
    final supplier =
        json['contacts'] != null ? json['contacts']['name'] : 'غير معروف';

    final itemsList = itemsJson.map((item) {
      final prodName =
          item['products'] != null ? item['products']['name'] : 'منتج';
      return PurchasesHistoryItemEntity(
        productName: prodName,
        quantity: item['quantity'] ?? 0,
        unitPrice: double.parse((item['unit_price'] ?? 0).toString()),
        totalPrice: double.parse((item['total_price'] ?? 0).toString()),
      );
    }).toList();

    return PurchasesHistoryModel(
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
      supplierName: supplier,
      subTotal: double.parse((json['sub_total'] ?? 0).toString()),
      discount: double.parse((json['discount'] ?? 0).toString()),
      grandTotal: double.parse((json['grand_total'] ?? 0).toString()),
      paidAmount: double.parse((json['paid_amount'] ?? 0).toString()),
      remainingAmount: double.parse((json['remaining_amount'] ?? 0).toString()),
      status: json['status'] ?? 'pending',
      items: itemsList,
    );
  }
}
