import '../../../domain/entities/account_entity.dart';

abstract class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<AccountEntity> accounts;
  const AccountLoaded(this.accounts);
}

class AccountError extends AccountState {
  final String message;
  const AccountError(this.message);
}
