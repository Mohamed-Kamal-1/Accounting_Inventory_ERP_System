// import 'package:accounting_desktop/features/reports/view/tabs/inventory_reports_tab.dart';
// import 'package:accounting_desktop/features/reports/view/tabs/purchases_reports_tab.dart';
// import 'package:accounting_desktop/features/reports/view/tabs/sales_reports_tab.dart';
// import 'package:flutter/material.dart';
// import '../../../core/app_text/reports_text/reports_screen_text.dart';
//
// import 'tabs/reps_reports_tab.dart';
// import 'tabs/finance_reports_tab.dart';
//
// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(ReportsStrings.mainTitle),
//           bottom: const TabBar(
//             isScrollable: true,
//             tabs: [
//               Tab(icon: Icon(Icons.inventory), text: ReportsStrings.invTab),
//               Tab(icon: Icon(Icons.monetization_on), text: ReportsStrings.salesTab),
//               Tab(icon: Icon(Icons.shopping_cart), text: ReportsStrings.buyTab),
//               Tab(icon: Icon(Icons.groups), text: ReportsStrings.repsTab),
//               Tab(icon: Icon(Icons.account_balance), text: ReportsStrings.financeTab),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             InventoryReportsTab(), // تعرض: قيمة المخزن، الهوالك، النواقص
//             SalesReportsTab(),     // تعرض: أكثر الأصناف مبيعاً، مبيعات العملاء
//             PurchasesReportsTab(), // تعرض: مشتريات الموردين، الفواتير المستحقة
//             RepsReportsTab(),      // تعرض: أداء مناديب المعاينة والبيع
//             FinanceReportsTab(),   // تعرض: الربح والخسارة، المصاريف الإدارية
//           ],
//         ),
//       ),
//     );
//   }
// }
