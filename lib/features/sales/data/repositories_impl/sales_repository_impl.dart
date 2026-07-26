import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/network/execute_supabase.dart';
import '../../domain/entities/sale_invoice_entity.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_datasource.dart';

@Injectable(as: SalesRepository)
class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource remoteDataSource;

  SalesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<bool>> createSaleInvoice(SaleInvoiceEntity invoice) async {
    return executeSupabase(() async {
      return await remoteDataSource.createSaleInvoice(invoice);
    });
  }
}
