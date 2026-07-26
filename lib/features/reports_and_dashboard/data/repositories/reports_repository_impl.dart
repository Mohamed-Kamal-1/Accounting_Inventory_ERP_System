import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';
import '../models/dashboard_stats_model.dart';

@Singleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;

  ReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    final data = await _remoteDataSource.fetchDashboardStats();
    return DashboardStatsModel.fromJson(data);
  }
}
