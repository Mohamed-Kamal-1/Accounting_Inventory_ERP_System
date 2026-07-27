import 'package:accounting_desktop/features/sales/domain/entities/sales_invoice_item_entity.dart';
import 'package:equatable/equatable.dart';

class SaleInvoiceEntity extends Equatable {
  final String? id;
  final String contactId;
  final String contactName;
  final String mode; // 'merchant', 'salesman', 'supplier'
  final DateTime date;
  final String city;
  final String lineName;
  final List<SaleInvoiceItemEntity> items;
  final double subTotal;
  final double invoiceDiscountPercent;
  final double grandTotal;
  final double paidAmount;
  final double remainingAmount;

  const SaleInvoiceEntity({
    this.id,
    required this.contactId,
    required this.contactName,
    required this.mode,
    required this.date,
    required this.city,
    required this.lineName,
    required this.items,
    required this.subTotal,
    required this.invoiceDiscountPercent,
    required this.grandTotal,
    required this.paidAmount,
    required this.remainingAmount,
  });

  @override
  List<Object?> get props => [id, contactId, items, grandTotal];
}
