import '../entities/invoice_entity.dart';

abstract class InvoicesRepository {
  Future<void> createInvoice(InvoiceEntity invoice);
}
