import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/sale_invoice_entity.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_datasource.dart';

@Injectable(as: SalesRepository)
class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource remoteDataSource;

  SalesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<bool>> createSaleInvoice(SaleInvoiceEntity invoice) async {
    try {
      final isSuccess = await remoteDataSource.createSaleInvoice(invoice);
      return Result.success(isSuccess);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } catch (e) {
      return Result.failure(
          ServerFailure(message: 'فشل الاتصال وحفظ الفاتورة'));
    }
  }
}
