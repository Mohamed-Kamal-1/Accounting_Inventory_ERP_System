import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../presentation/widgets/report_filter_header.dart';
import '../../presentation/widgets/report_summary_card.dart';

class RepsReportsTab extends StatelessWidget {
  const RepsReportsTab({super.key});

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
              ReportSummaryCard(title: "أعلى مندوب مبيعات", value: "أحمد علي", color: Colors.orange),
              ReportSummaryCard(title: "عدد المعاينات", value: "140", color: Colors.blueGrey),
            ],
          ),
          // جدول يوضح (اسم المندوب | مبيعاته | عمولته | عدد زياراته)
        ],
      ),
    );
  }
}