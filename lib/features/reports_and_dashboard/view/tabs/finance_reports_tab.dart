import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../presentation/widgets/report_filter_header.dart';
import '../../presentation/widgets/report_summary_card.dart';

class FinanceReportsTab extends StatelessWidget {
  const FinanceReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ReportFilterHeader(),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 15,
            children: [
              ReportSummaryCard(title: "إجمالي الإيرادات", value: "55,000 ج.م", color: Colors.green),
              ReportSummaryCard(title: "إجمالي المصروفات", value: "12,000 ج.م", color: Colors.red),
              ReportSummaryCard(title: "صافي الربح", value: "43,000 ج.م", color: Colors.blue),
            ],
          ),
          const SizedBox(height: 20),
          // هنا نضع جدول حركة الخزينة (DataTable)
        ],
      ),
    );
  }
}