import '../../domain/entities/dashboard_stats_entity.dart';

abstract class ReportsState {
  const ReportsState();
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final DashboardStatsEntity stats;
  const ReportsLoaded(this.stats);
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
}
