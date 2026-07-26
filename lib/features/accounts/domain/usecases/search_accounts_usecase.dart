import 'package:injectable/injectable.dart';

import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

@injectable
class SearchAccountsUseCase {
  final AccountsRepository repository;

  SearchAccountsUseCase(this.repository);

  Future<List<AccountEntity>> call(String query, String type) async {
    return await repository.searchAccounts(query, type);
  }
}
