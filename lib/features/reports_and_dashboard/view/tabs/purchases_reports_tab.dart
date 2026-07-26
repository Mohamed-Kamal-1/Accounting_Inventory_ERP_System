import 'package:flutter/material.dart';

import '../../presentation/widgets/report_filter_header.dart';
import '../../presentation/widgets/report_summary_card.dart';


class PurchasesReportsTab extends StatelessWidget {
  const PurchasesReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ReportFilterHeader(),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 15, runSpacing: 15,
            children: [
              ReportSummaryCard(title: "إجمالي المشتريات", value: "62,000 ج.م", color: Colors.indigo),
              ReportSummaryCard(title: "مدفوعات اليوم", value: "5,000 ج.م", color: Colors.blueGrey),
              ReportSummaryCard(title: "مشتريات آجلة", value: "18,000 ج.م", color: Colors.deepOrange),
            ],
          ),
          const SizedBox(height: 25),
          const PurchasesReportTable(),
        ],
      ),
    );
  }
}

class PurchasesReportTable extends StatelessWidget {
  const PurchasesReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width - 32),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.indigo[50]),
            columns: const [
              DataColumn(label: Text("رقم الفاتورة")),
              DataColumn(label: Text("المورد")),
              DataColumn(label: Text("التاريخ")),
              DataColumn(label: Text("الإجمالي")),
              DataColumn(label: Text("الحالة")),
            ],
            rows: const [],
          ),
        ),
      ),
    );
  }
}