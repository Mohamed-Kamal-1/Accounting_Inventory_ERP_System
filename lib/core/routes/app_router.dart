import 'dart:async';

import 'package:accounting_desktop/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/auth/presentation/view/register_screen.dart';
import '../../features/contacts/presentation/view/contacts_screen.dart';
import '../../features/inventory/presentation/view/inventory_screen.dart';
import '../../features/purchases/presentation/view/add_purchase_screen.dart';
import '../../features/purchases_history/presentation/view/purchases_history_screen.dart';
import '../../features/reports_and_dashboard/view/dashboard_screen.dart';
import '../../features/sales/presentation/view/sales_screen.dart';
import '../../features/sales_history/presentation/view/sales_history_screen.dart';
import '../../layout/main_layout.dart';
import '../../splash_screen.dart';
import 'app_routes.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();

    _subscription = stream.listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }
}

class AppRouter {
  static const String errorPath = "المسار غير موجود:";
  static const String mainPath = "العودة للرئيسية";

  static GoRouter createRouter() {
    final authCubit = getIt.get<AuthCubit>();

    return GoRouter(
      initialLocation: AppRoute.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final isGoingToLogin = state.matchedLocation == AppRoute.login;
        final isGoingToSplash = state.matchedLocation == AppRoute.splash;
        // 💡 إضافة مسار التسجيل لكي نسمح للزوار بالوصول إليه
        final isGoingToRegister = state.matchedLocation == AppRoute.register;

        if (authState is AuthLoading) return null;

        // حالة الزائر (غير مسجل الدخول)
        if (authState is AuthInitial || authState is AuthError) {
          // اسمح له بالبقاء فقط إذا كان في الدخول، أو السبلاش، أو التسجيل
          if (!isGoingToLogin && !isGoingToSplash && !isGoingToRegister) {
            return AppRoute.login; // اطرد أي محاولة اختراق لشاشات النظام
          }
        }
        // حالة المستخدم الموثق (مسجل الدخول بنجاح)
        else if (authState is AuthSuccess) {
          // إذا حاول الرجوع للخلف لصفحات الدخول أو التسجيل، امنعه ووجهه للوحة القيادة
          if (isGoingToLogin || isGoingToSplash || isGoingToRegister) {
            return AppRoute.dashboard;
          }
        }
        return null; // في أي حالة أخرى طبيعية، اسمح بالمرور
      },
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$errorPath ${state.uri.toString()}'),
              ElevatedButton(
                onPressed: () => context.go(AppRoute.dashboard),
                child: const Text(mainPath),
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
        GoRoute(
          path: AppRoute.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoute.salesHistory,
          builder: (context, state) => const SalesHistoryScreen(),
        ),
        GoRoute(
          path: AppRoute.purchasesHistory,
          builder: (context, state) => const PurchasesHistoryScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainLayout(navigationShell: navigationShell);
          },
          branches: [
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
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.purchases,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: AddPurchaseScreen(),
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
