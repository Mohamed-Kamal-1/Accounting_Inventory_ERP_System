import 'package:flutter/material.dart';
import '../../presentation/widgets/report_filter_header.dart';
import '../../presentation/widgets/report_summary_card.dart';


class InventoryReportsTab extends StatelessWidget {
  const InventoryReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ReportFilterHeader(), // البحث والتاريخ
          const SizedBox(height: 20),
          const Wrap(
            spacing: 15, runSpacing: 15,
            children: [
              ReportSummaryCard(title: "إجمالي قيمة المخزن", value: "120,500 ج.م", color: Colors.blue),
              ReportSummaryCard(title: "عدد الأصناف", value: "450 صنف", color: Colors.blueGrey),
              ReportSummaryCard(title: "أصناف منتهية", value: "12 صنف", color: Colors.red),
            ],
          ),
          const SizedBox(height: 25),
          const InventoryReportTable(),
        ],
      ),
    );
  }
}

class InventoryReportTable extends StatelessWidget {
  const InventoryReportTable({super.key});

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
            headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
            columns: const [
              DataColumn(label: Text("اسم الصنف")),
              DataColumn(label: Text("الكمية الحالية")),
              DataColumn(label: Text("سعر التكلفة")),
              DataColumn(label: Text("إجمالي القيمة")),
              DataColumn(label: Text("آخر حركة")),
            ],
            rows: const [], // سيتم ملؤها بربط البيانات
          ),
        ),
      ),
    );
  }
}