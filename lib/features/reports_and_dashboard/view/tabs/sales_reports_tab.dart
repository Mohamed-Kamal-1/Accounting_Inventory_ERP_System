import 'package:flutter/material.dart';
import '../../../../core/app_text/reports_text/reports_screen_text.dart';
import '../../presentation/widgets/app_date_picker.dart';
import '../../presentation/widgets/report_summary_card.dart';


class SalesReportsTab extends StatelessWidget {
  const SalesReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isPC = width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. قسم الفلترة المطور (بحث + من تاريخ + إلى تاريخ)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16, runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // حقل البحث
                  SizedBox(
                    width: isPC ? 250 : double.infinity,
                    child: const TextField(
                      decoration: InputDecoration(
                          hintText: "بحث برقم الفاتورة أو العميل...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  // اختيار تاريخ البداية
                  SizedBox(width: isPC ? 180 : double.infinity, child: const AppDatePicker(label: "من تاريخ")),
                  // اختيار تاريخ النهاية
                  SizedBox(width: isPC ? 180 : double.infinity, child: const AppDatePicker(label: "إلى تاريخ")),
                  // زر التحديث
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
                    onPressed: () {},
                    icon: const Icon(Icons.analytics),
                    label: const Text(ReportsStrings.showReport),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. كروت الإحصائيات (Summary Cards)
          const Wrap(
            spacing: 15, runSpacing: 15,
            children: [
              ReportSummaryCard(title: "إجمالي المبيعات", value: "85,200 ج.م", color: Colors.green),
              ReportSummaryCard(title: "صافي الأرباح", value: "15,400 ج.م", color: Colors.teal),
              ReportSummaryCard(title: "عدد الفواتير", value: "124 فاتورة", color: Colors.orange),
            ],
          ),

          const SizedBox(height: 25),

          // 3. الجدول مع إضافة عمود المندوب
          const SalesReportTable(),
        ],
      ),
    );
  }
}

class SalesReportTable extends StatelessWidget {
  const SalesReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8)
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width - 32),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.green[50]),
            columns: const [
              DataColumn(label: Text("رقم الفاتورة", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("التاريخ", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("العميل", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("المندوب", style: TextStyle(fontWeight: FontWeight.bold))), // عمود المندوب المطلوب
              DataColumn(label: Text("الإجمالي", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("طريقة الدفع", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: const [], // ستملأ من قاعدة البيانات
          ),
        ),
      ),
    );
  }
}