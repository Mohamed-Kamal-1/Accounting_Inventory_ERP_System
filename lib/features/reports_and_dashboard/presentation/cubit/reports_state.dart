import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/entities/treasury_transaction_entity.dart'; // 💡 استيراد الكيان الجديد

abstract class ReportsState {
  const ReportsState();
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final DashboardStatsEntity stats; // الإحصائيات (القديم)
  final List<TreasuryTransactionEntity> transactions; // حركات الخزينة (الجديد)

  const ReportsLoaded({
    required this.stats,
    required this.transactions,
  });
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
}
