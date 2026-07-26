import 'package:injectable/injectable.dart';

import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

@lazySingleton
class GetAccountsUseCase {
  final AccountsRepository _repository;

  GetAccountsUseCase(this._repository);

  Future<List<AccountEntity>> call(String type) async {
    return await _repository.getAccounts(type);
  }
}
