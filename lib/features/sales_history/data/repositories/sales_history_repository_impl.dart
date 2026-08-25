import 'package:injectable/injectable.dart';

import '../../../../core/error/result.dart';
import '../../../../core/network/execute_supabase.dart';
import '../../domain/entities/invoice_details_entity.dart';
import '../../domain/entities/invoice_header_entity.dart';
import '../../domain/repositories/sales_history_repository.dart';
import '../datasources/sales_history_remote_data_source.dart';

@LazySingleton(as: SalesHistoryRepository)
class SalesHistoryRepositoryImpl implements SalesHistoryRepository {
  final SalesHistoryRemoteDataSource remoteDataSource;

  SalesHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<InvoiceHeaderEntity>>> getSalesHistory({
    required String searchTerm,
    required int limit,
    DateTime? startDate,
    DateTime? endDate,
    required int offset,
  }) {
    return executeSupabase(() => remoteDataSource.getSalesHistory(
          searchTerm: searchTerm,
          limit: limit,
          offset: offset,
        ));
  }

  @override
  Future<Result<List<InvoiceDetailsEntity>>> getInvoiceDetails(
      String invoiceId) {
    return executeSupabase(() => remoteDataSource.getInvoiceDetails(invoiceId));
  }
}
