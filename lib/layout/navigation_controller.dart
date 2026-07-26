import 'package:flutter/material.dart';

import '../ widgets/app_screen.dart';
import '../features/accounts/presentation/view/accounts_screen.dar.dart';
import '../features/inventory/presentation/view/inventory_screen.dart';
import '../features/reports_and_dashboard/view/dashboard_screen.dart';

class NavigationController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AppScreen _currentScreen = AppScreen.dashboard;
  AppScreen get currentScreen => _currentScreen;

  void changeScreen(AppScreen screen) {
    if (_currentScreen == screen) return;
    _currentScreen = screen;
    notifyListeners();
  }

  Widget get currentWidget {
    switch (_currentScreen) {
      case AppScreen.dashboard:
        return const DashboardScreen();
      case AppScreen.inventory:
        return const InventoryScreen();
      case AppScreen.accounts:
        return const AccountsScreen();
      // case AppScreen.sales:
      //   return const CreateInvoiceScreen(invoiceType: 'sales');
      // case AppScreen.purchases:
      //   return const CreateInvoiceScreen(invoiceType: 'purchase');
      default:
        return const SizedBox.shrink();
    }
  }
}
