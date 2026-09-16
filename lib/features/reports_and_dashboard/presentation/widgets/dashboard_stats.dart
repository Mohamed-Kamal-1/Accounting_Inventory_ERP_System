import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import 'modern_stat_card.dart';

class DashboardStatsWidget extends StatelessWidget {
  final double screenWidth;
  const DashboardStatsWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading) {
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ReportsError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text('حدث خطأ: ${state.message}',
                  style: const TextStyle(color: Colors.red, fontSize: 16)),
            ),
          );
        } else if (state is ReportsLoaded) {
          final stats = state.stats;
          return SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ModernStatCard(
                  title: 'إجمالي المبيعات',
                  val: stats.totalSales.toStringAsFixed(2),
                  color: const Color(0xFF10B981),
                  icon: Icons.point_of_sale_rounded,
                  screenWidth: screenWidth,
                ),
                ModernStatCard(
                  title: 'إجمالي المشتريات',
                  val: stats.totalPurchases.toStringAsFixed(2),
                  color: const Color(0xFFEF4444),
                  icon: Icons.shopping_cart_rounded,
                  screenWidth: screenWidth,
                ),
                ModernStatCard(
                  title: 'عدد العملاء',
                  val: stats.customersCount.toString(),
                  color: const Color(0xFFF59E0B),
                  icon: Icons.groups_rounded,
                  screenWidth: screenWidth,
                ),
                ModernStatCard(
                  title: 'قيمة المخزون',
                  val: stats.inventoryValue.toStringAsFixed(2),
                  color: const Color(0xFF3B82F6),
                  icon: Icons.inventory_2_rounded,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
