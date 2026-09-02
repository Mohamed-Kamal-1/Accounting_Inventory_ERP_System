import '../entities/purchases_history_entity.dart';

abstract class PurchasesHistoryRepository {
  Future<List<PurchasesHistoryEntity>> getPurchasesHistory();
}
