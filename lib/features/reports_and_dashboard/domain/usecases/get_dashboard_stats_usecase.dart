import 'package:injectable/injectable.dart';

import '../entities/dashboard_stats_entity.dart';
import '../repositories/reports_repository.dart';

@injectable
class GetDashboardStatsUseCase {
  final ReportsRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<DashboardStatsEntity> call() async {
    return await repository.getDashboardStats();
  }
}
