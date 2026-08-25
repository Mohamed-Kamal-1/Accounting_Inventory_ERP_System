import '../../../../core/error/result.dart';
import '../entities/invoice_details_entity.dart';
import '../entities/invoice_header_entity.dart';

abstract class SalesHistoryRepository {
  Future<Result<List<InvoiceHeaderEntity>>> getSalesHistory({
    required String searchTerm,
    DateTime? startDate,
    DateTime? endDate,
    required int limit,
    required int offset,
  });

  Future<Result<List<InvoiceDetailsEntity>>> getInvoiceDetails(
      String invoiceId);
}
