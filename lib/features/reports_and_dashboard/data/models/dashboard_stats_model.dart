import '../../domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalSales,
    required super.totalPurchases,
    required super.customersCount,
    required super.inventoryValue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      totalPurchases: (json['total_purchases'] as num?)?.toDouble() ?? 0.0,
      customersCount: (json['customers_count'] as num?)?.toInt() ?? 0,
      inventoryValue: (json['inventory_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
