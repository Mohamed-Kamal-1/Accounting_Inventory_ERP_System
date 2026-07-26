import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import 'reports_state.dart';

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;

  ReportsCubit(this._getDashboardStatsUseCase) : super(ReportsInitial());

  Future<void> loadDashboardStats() async {
    emit(ReportsLoading());
    try {
      final stats = await _getDashboardStatsUseCase();
      emit(ReportsLoaded(stats));
    } catch (e) {
      emit(ReportsError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
