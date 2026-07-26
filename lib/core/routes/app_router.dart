import 'package:accounting_desktop/features/sales/presentation/view/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/contacts/presentation/view/contacts_screen.dart';
import '../../features/inventory/presentation/view/inventory_screen.dart';
import '../../features/reports_and_dashboard/view/dashboard_screen.dart';
import '../../layout/main_layout.dart';
import '../../splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoute.splash,
    routes: [
      GoRoute(
        path: AppRoute.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoute.dashboard,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoute.sales,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SalesScreen(),
            ),
          ),
          GoRoute(
            path: AppRoute.contacts,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ContactsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoute.inventory,
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
              path: AppRoute.purchases,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'المشتريات')),
          GoRoute(
              path: AppRoute.returns,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'المرتجعات')),
          GoRoute(
              path: AppRoute.todayInvoices,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'سداد وتحصيل نقدي')),
          GoRoute(
              path: AppRoute.adminExpenses,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'المصروفات')),
          GoRoute(
              path: AppRoute.adminPreviews,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'مراجعة المعاينات')),
          GoRoute(
              path: AppRoute.agentsReport,
              pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const _PlaceholderScreen(title: 'تقارير المناديب'))),
          GoRoute(
              path: AppRoute.adminMonitor,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'الزيارات والخطوط')),
          GoRoute(
              path: AppRoute.damages,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'التوالف')),
          GoRoute(
              path: AppRoute.statement,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'كشوفات الحسابات')),
          GoRoute(
              path: AppRoute.reports,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'التقارير المالية')),
          GoRoute(
              path: AppRoute.settings,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'الإعدادات')),
          GoRoute(
              path: AppRoute.salesmanInventory,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'مخزن المندوب')),
          GoRoute(
              path: AppRoute.repVisit,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'الزيارات')),
          GoRoute(
              path: AppRoute.salesmanSales,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'فاتورة بيع مندوب')),
          GoRoute(
              path: AppRoute.salesReturn,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'مرتجع بيع')),
          GoRoute(
              path: AppRoute.collectPayment,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'سداد نقدي')),
          GoRoute(
              path: AppRoute.salesmanCustomers,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'كشف حساب تاجر')),
          GoRoute(
              path: AppRoute.preview,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'المعاينات')),
          GoRoute(
              path: AppRoute.agentTasks,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'طلبات المعاينات')),
          GoRoute(
              path: AppRoute.previewRequest,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'طلب معاينة')),
          GoRoute(
              path: AppRoute.plumberDash,
              builder: (context, state) =>
                  const _PlaceholderScreen(title: 'تقارير السباكين')),
        ],
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'شاشة ($title) قيد التطوير...',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
