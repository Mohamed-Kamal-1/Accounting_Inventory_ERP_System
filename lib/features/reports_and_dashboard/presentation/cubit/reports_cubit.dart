import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_treasury_transactions_usecase.dart';
import 'reports_state.dart';

@lazySingleton
class ReportsCubit extends Cubit<ReportsState> {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;
  final GetTreasuryTransactionsUseCase _getTreasuryTransactionsUseCase;

  DateTime? currentStartDate;
  DateTime? currentEndDate;

  ReportsCubit(
    this._getDashboardStatsUseCase,
    this._getTreasuryTransactionsUseCase,
  ) : super(ReportsInitial());

  Future<void> loadDashboardStats(
      {DateTime? startDate, DateTime? endDate}) async {
    currentStartDate = startDate ?? currentStartDate;
    currentEndDate = endDate ?? currentEndDate;

    emit(ReportsLoading());
    try {
      final stats = await _getDashboardStatsUseCase();
      final transactions = await _getTreasuryTransactionsUseCase(
        startDate: currentStartDate,
        endDate: currentEndDate,
      );

      emit(ReportsLoaded(
        stats: stats,
        transactions: transactions,
      ));
    } catch (e) {
      emit(ReportsError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> addManualDeposit({
    required double amount,
    required String description,
  }) async {
    try {
      await _getTreasuryTransactionsUseCase.addManualDeposit(
        amount: amount,
        description: description,
      );
      await loadDashboardStats();
    } catch (e) {
      emit(ReportsError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
