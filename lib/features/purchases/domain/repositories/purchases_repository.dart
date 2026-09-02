import '../entities/purchase_invoice_entity.dart';

abstract class PurchasesRepository {
  Future<void> savePurchaseInvoice(PurchaseInvoiceEntity invoice);
}
