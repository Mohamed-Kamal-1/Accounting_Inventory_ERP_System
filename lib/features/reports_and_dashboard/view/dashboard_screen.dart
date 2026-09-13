import 'package:accounting_desktop/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/shorebird_updater.dart';
import '../presentation/cubit/reports_cubit.dart';
import '../presentation/cubit/reports_state.dart';
import '../presentation/widgets/modern_stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateService.checkForUpdates(context);
    });
  }

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _setTodayFilter(BuildContext context) {
    final now = DateTime.now();
    setState(() {
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = DateTime(now.year, now.month, now.day);
    });
    context.read<ReportsCubit>().loadDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return BlocProvider(
      create: (context) => getIt.get<ReportsCubit>()..loadDashboardStats(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F7FB),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 10,
                          children: [
                            const Text(
                              'لوحة التحكم و قط',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _openAddModal(context),
                              icon: const Icon(Icons.add_circle_outline,
                                  size: 22),
                              label: const Text('إيداع مبالغ إضافية',
                                  style: TextStyle(fontSize: 15)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            const Text('تصفية بالمدة:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            DateInputWidget(
                              dateText: _formatDate(_startDate),
                              onTap: () => _selectDate(context, true),
                            ),
                            const Text('إلى:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            DateInputWidget(
                              dateText: _formatDate(_endDate),
                              onTap: () => _selectDate(context, false),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ReportsCubit>()
                                    .loadDashboardStats();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('عرض النتائج',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _setTodayFilter(context),
                              icon: const Icon(Icons.today, size: 18),
                              label: const Text('شغل اليوم'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<ReportsCubit, ReportsState>(
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
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16)),
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
                                    val:
                                        stats.totalPurchases.toStringAsFixed(2),
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
                                    val:
                                        stats.inventoryValue.toStringAsFixed(2),
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
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.receipt_long,
                                    color: Color(0xFF64748B)),
                                SizedBox(width: 10),
                                Text(
                                  'تفاصيل حركة النقدية',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B)),
                                ),
                              ],
                            ),
                            const Divider(height: 30, color: Color(0xFFE2E8F0)),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.analytics_outlined,
                                      size: 60, color: Colors.grey.shade300),
                                  const SizedBox(height: 15),
                                  Text(
                                    'جاري برمجة وتجهيز الجدول السردي...',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openAddModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('إضافة سيولة يدوية',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'المبلغ',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'البيان',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('حفظ العملية',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class DateInputWidget extends StatelessWidget {
  final String dateText;
  final VoidCallback? onTap;

  const DateInputWidget({
    super.key,
    required this.dateText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF8FAFC),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 16, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Text(
              dateText,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
