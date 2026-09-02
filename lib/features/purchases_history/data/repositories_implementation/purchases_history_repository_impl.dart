import 'package:injectable/injectable.dart';

import '../../domain/entities/purchases_history_entity.dart';
import '../../domain/repositories/purchases_history_repository.dart';
import '../datasources/purchases_history_remote_datasource.dart';

@Singleton(as: PurchasesHistoryRepository)
class PurchasesHistoryRepositoryImpl implements PurchasesHistoryRepository {
  final PurchasesHistoryRemoteDataSource _remoteDataSource;

  PurchasesHistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PurchasesHistoryEntity>> getPurchasesHistory() async {
    return await _remoteDataSource.getPurchasesHistory();
  }
}
