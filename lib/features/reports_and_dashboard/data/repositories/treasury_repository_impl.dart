import 'package:injectable/injectable.dart';

import '../../domain/entities/treasury_transaction_entity.dart';
import '../../domain/repositories/treasury_repository.dart';
import '../datasources/treasury_remote_datasource.dart';

@Singleton(as: TreasuryRepository)
class TreasuryRepositoryImpl implements TreasuryRepository {
  final TreasuryRemoteDataSource _remoteDataSource;

  TreasuryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TreasuryTransactionEntity>> getTransactions(
      {DateTime? startDate, DateTime? endDate}) async {
    final startStr = startDate != null
        ? "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}"
        : null;
    final endStr = endDate != null
        ? "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}"
        : null;

    return await _remoteDataSource.getTransactions(startStr, endStr);
  }

  @override
  Future<void> addManualDeposit(
      {required double amount, required String description}) async {
    await _remoteDataSource.insertManualDeposit(amount, description);
  }
}
