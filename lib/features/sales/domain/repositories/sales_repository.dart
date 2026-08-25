import '../../../../core/error/result.dart';
import '../entities/sale_invoice_entity.dart';

abstract class SalesRepository {
  Future<Result<bool>> createSaleInvoice(SaleInvoiceEntity invoice);
}
