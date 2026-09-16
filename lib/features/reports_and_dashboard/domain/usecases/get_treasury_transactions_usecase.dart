import 'package:injectable/injectable.dart';

import '../entities/treasury_transaction_entity.dart';
import '../repositories/treasury_repository.dart';

@injectable
class GetTreasuryTransactionsUseCase {
  final TreasuryRepository _repository;

  GetTreasuryTransactionsUseCase(this._repository);

  Future<List<TreasuryTransactionEntity>> call(
      {DateTime? startDate, DateTime? endDate}) async {
    return await _repository.getTransactions(
        startDate: startDate, endDate: endDate);
  }

  Future<void> addManualDeposit(
      {required double amount, required String description}) async {
    await _repository.addManualDeposit(
        amount: amount, description: description);
  }
}
