import 'invoice_item_entity.dart';

class InvoiceEntity {
  final String id;
  final String type;
  final String accountId;
  final String repId;
  final String date;
  final double total;
  final List<InvoiceItemEntity> items;

  const InvoiceEntity({
    required this.id,
    required this.type,
    required this.accountId,
    required this.repId,
    required this.date,
    required this.total,
    required this.items,
  });
}
