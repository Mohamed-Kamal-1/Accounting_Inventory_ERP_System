import '../entities/treasury_transaction_entity.dart';

abstract class TreasuryRepository {
  Future<List<TreasuryTransactionEntity>> getTransactions(
      {DateTime? startDate, DateTime? endDate});
  Future<void> addManualDeposit(
      {required double amount, required String description});
}
