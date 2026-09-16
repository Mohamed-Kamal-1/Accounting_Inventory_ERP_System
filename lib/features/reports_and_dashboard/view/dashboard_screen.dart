import 'package:accounting_desktop/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/shorebird_updater.dart';
import '../presentation/cubit/reports_cubit.dart';
import '../presentation/widgets/cash_flow_details.dart';
import '../presentation/widgets/dashboard_filters.dart';
import '../presentation/widgets/dashboard_header.dart';
import '../presentation/widgets/dashboard_stats.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateService.checkForUpdates(context);
    });
  }

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
    final isMobile = screenWidth < 600;

    return BlocProvider(
      create: (context) => getIt.get<ReportsCubit>()
        ..loadDashboardStats(startDate: _startDate, endDate: _endDate),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F7FB),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardHeaderWidget(isMobile: isMobile),
                      const SizedBox(height: 20),
                      DashboardFiltersWidget(
                        isMobile: isMobile,
                        startDateText: _formatDate(_startDate),
                        endDateText: _formatDate(_endDate),
                        onStartDateTap: () => _selectDate(context, true),
                        onEndDateTap: () => _selectDate(context, false),
                        onShowResultsTap: () =>
                            context.read<ReportsCubit>().loadDashboardStats(),
                        onTodayTap: () => _setTodayFilter(context),
                      ),
                      const SizedBox(height: 24),
                      DashboardStatsWidget(screenWidth: screenWidth),
                      const SizedBox(height: 24),
                      const CashFlowDetailsWidget(),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF8FAFC),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 14, color: Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                dateText,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
