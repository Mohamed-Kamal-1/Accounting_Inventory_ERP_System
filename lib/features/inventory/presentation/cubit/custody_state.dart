import '../../domain/entities/inventory_transaction_entity.dart';
import '../../domain/entities/salesman_custody_entity.dart';
import 'custody_cubit.dart';

class CustodyLoading extends CustodyState {}

class CustodyLoaded extends CustodyState {
  final List<InventoryTransactionEntity> transactions;
  final List<SalesmanCustodyEntity> currentCustody;

  const CustodyLoaded(
      {required this.transactions, required this.currentCustody});

  @override
  List<Object?> get props => [transactions, currentCustody];
}

class CustodyError extends CustodyState {
  final String message;
  const CustodyError(this.message);

  @override
  List<Object?> get props => [message];
}
