import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/inventory_repository.dart';
import 'custody_state.dart';

// --- States ---
abstract class CustodyState extends Equatable {
  const CustodyState();
  @override
  List<Object?> get props => [];
}

class CustodyInitial extends CustodyState {}

@injectable
class CustodyCubit extends Cubit<CustodyState> {
  final InventoryRepository _repository;

  CustodyCubit(this._repository) : super(CustodyInitial());

  Future<void> loadSalesmanCustody(String salesmanId) async {
    emit(CustodyLoading());

    final txResult =
        await _repository.getCustodyTransactions(salesmanId: salesmanId);
    final custodyResult =
        await _repository.getSalesmanCurrentCustody(salesmanId);

    txResult.fold(
      onFailure: (failure) => emit(CustodyError(failure.message)),
      onSuccess: (transactions) {
        custodyResult.fold(
          onFailure: (failure) => emit(CustodyError(failure.message)),
          onSuccess: (currentCustody) {
            emit(CustodyLoaded(
              transactions: transactions,
              currentCustody: currentCustody,
            ));
          },
        );
      },
    );
  }
}
