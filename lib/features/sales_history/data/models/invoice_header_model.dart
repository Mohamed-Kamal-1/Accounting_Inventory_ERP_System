import '../../domain/entities/invoice_header_entity.dart';

class InvoiceHeaderModel extends InvoiceHeaderEntity {
  const InvoiceHeaderModel({
    required super.id,
    required super.createdAt,
    required super.invoiceType,
    required super.subTotal,
    required super.discount,
    required super.grandTotal,
    required super.paidAmount,
    required super.remainingAmount,
    required super.contactId,
    required super.contactName,
  });

  factory InvoiceHeaderModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return InvoiceHeaderModel(
      id: json['id']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'].toString())?.toLocal() ??
          DateTime.now(),
      invoiceType: json['invoice_type']?.toString() ?? '',
      subTotal: parseDouble(json['sub_total']),
      discount: parseDouble(json['discount']),
      grandTotal: parseDouble(json['grand_total']),
      paidAmount: parseDouble(json['paid_amount']),
      remainingAmount: parseDouble(json['remaining_amount']),
      contactId: json['contact_id']?.toString() ?? '',
      contactName: json['contact_name']?.toString() ?? 'غير محدد',
    );
  }
}
