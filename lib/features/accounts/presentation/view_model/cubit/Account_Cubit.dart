import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/add_account_usecase.dart';
import '../../../domain/usecases/delete_account_usecase.dart';
import '../../../domain/usecases/get_accounts_usecase.dart';
import '../../../domain/usecases/search_accounts_usecase.dart';
import 'Accounts_State.dart';

@injectable
class AccountCubit extends Cubit<AccountState> {
  final GetAccountsUseCase _getAccountsUseCase;
  final AddAccountUseCase _addAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final SearchAccountsUseCase _searchAccountsUseCase;

  AccountCubit(
    this._getAccountsUseCase,
    this._addAccountUseCase,
    this._deleteAccountUseCase,
    this._searchAccountsUseCase,
  ) : super(AccountInitial());

  Future<void> fetchAccounts(String type) async {
    emit(AccountLoading());
    try {
      List<AccountEntity> allAccounts;

      if (type == 'all') {
        allAccounts = await _getAccountsUseCase('');
      } else {
        allAccounts = await _getAccountsUseCase(type);
      }

      if (type == 'all') {
        emit(AccountLoaded(allAccounts));
      } else {
        final filtered = allAccounts
            .where(
                (a) => a.type.trim().toLowerCase() == type.trim().toLowerCase())
            .toList();
        emit(AccountLoaded(filtered));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> createAccount(AccountEntity account) async {
    try {
      await _addAccountUseCase(account);
      await fetchAccounts(account.type);
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> removeAccount(String id, String type) async {
    try {
      await _deleteAccountUseCase(id);
      await fetchAccounts(type);
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> search(String query, String type) async {
    if (query.isEmpty) {
      await fetchAccounts(type);
      return;
    }
    try {
      final filtered = await _searchAccountsUseCase(query, type);
      emit(AccountLoaded(filtered));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
