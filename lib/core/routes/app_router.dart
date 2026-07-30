import 'dart:async';

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
  static GoRouter createRouter(AuthCubit authCubit) {
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
        body: Center(child: Text('المسار غير موجود: ${state.uri.toString()}')),
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
        ShellRoute(
          builder: (context, state, child) {
            return MainLayout(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoute.dashboard,
              pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey, child: const DashboardScreen()),
            ),
            GoRoute(
              path: AppRoute.sales,
              pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey, child: const SalesScreen()),
            ),
            GoRoute(
              path: AppRoute.contacts,
              pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey, child: const ContactsScreen()),
            ),
            GoRoute(
              path: AppRoute.inventory,
              pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey, child: const InventoryScreen()),
            ),
          ],
        ),
      ],
    );
  }
}
