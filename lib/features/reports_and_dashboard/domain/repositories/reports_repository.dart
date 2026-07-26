import '../entities/dashboard_stats_entity.dart';

abstract class ReportsRepository {
  Future<DashboardStatsEntity> getDashboardStats();
}
