import 'dart:async';

import 'package:accounting_desktop/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/contacts/presentation/view/contacts_screen.dart';
import '../../features/inventory/presentation/view/inventory_screen.dart';
import '../../features/reports_and_dashboard/view/dashboard_screen.dart';
import '../../features/sales/presentation/view/sales_screen.dart';
import '../../layout/main_layout.dart';
import '../../splash_screen.dart';
import 'app_routes.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();

    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }
}

class AppRouter {
  static GoRouter createRouter() {
    // 1. استدعاء Cubit مباشرة من GetIt بدلاً من تمريره
    final authCubit = getIt.get<AuthCubit>();

    return GoRouter(
      initialLocation: AppRoute.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final isGoingToLogin = state.matchedLocation == AppRoute.login;
        final isGoingToSplash = state.matchedLocation == AppRoute.splash;

        if (authState is AuthLoading) return null;

        if (authState is AuthInitial || authState is AuthError) {
          if (!isGoingToLogin && !isGoingToSplash) {
            return AppRoute.login;
          }
        } else if (authState is AuthSuccess) {
          if (isGoingToLogin || isGoingToSplash) {
            return AppRoute.dashboard;
          }
        }
        return null;
      },
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('المسار غير موجود: ${state.uri.toString()}'),
              ElevatedButton(
                // تصحيح كارثة context.pop() السابقة
                onPressed: () => context.go(AppRoute.dashboard),
                child: const Text('العودة للرئيسية'),
              )
            ],
          ),
        ),
      ),
      routes: [
        GoRoute(
          path: AppRoute.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoute.login,
          builder: (context, state) => const LoginScreen(),
        ),

        // 2. تطبيق StatefulShellRoute لمنع فقدان البيانات
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            // تمرير navigationShell للـ Layout بدلاً من child
            return MainLayout(navigationShell: navigationShell);
          },
          branches: [
            // الفرع الأول: لوحة التحكم
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.dashboard,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: DashboardScreen(),
                  ),
                ),
              ],
            ),
            // الفرع الثاني: المبيعات
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.sales,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: SalesScreen(),
                  ),
                ),
              ],
            ),
            // الفرع الثالث: جهات الاتصال
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.contacts,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ContactsScreen(),
                  ),
                ),
              ],
            ),
            // الفرع الرابع: المخازن
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.inventory,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: InventoryScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
