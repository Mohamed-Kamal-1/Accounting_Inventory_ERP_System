import 'package:flutter/material.dart';

import '../ widgets/app_screen.dart';
import '../core/app_text/layout_strings/layout_strings.dart';
import '../core/dimensions/Dimension_app.dart';
import 'navItem_widget.dart';

class SidebarWidget extends StatelessWidget {
  final AppScreen currentScreen;
  final Function(AppScreen) onItemSelected;
  final VoidCallback onLogout;

  const SidebarWidget({
    super.key,
    required this.currentScreen,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimension.widthSidebar260,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          const SizedBox(height: Dimension.heightSizeBox30),
          const Icon(Icons.business, color: Colors.white, size: 60),
          const SizedBox(height: Dimension.heightSizeBox12),
          const Text(
            LayoutStrings.appName,
            style: TextStyle(
                color: Colors.white,
                fontSize: Dimension.size18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Dimension.heightSizeBox30),
          Expanded(
            child: ListView(
              children: [
                NavItemWidget(
                  icon: Icons.dashboard,
                  title: LayoutStrings.dashboard,
                  screen: AppScreen.dashboard,
                  currentScreen: currentScreen,
                  onItemSelected: onItemSelected,
                ),
                NavItemWidget(
                  icon: Icons.inventory_2,
                  title: LayoutStrings.inventory,
                  screen: AppScreen.inventory,
                  currentScreen: currentScreen,
                  onItemSelected: onItemSelected,
                ),
                NavItemWidget(
                  icon: Icons.people,
                  title: LayoutStrings.accounts,
                  screen: AppScreen.accounts,
                  currentScreen: currentScreen,
                  onItemSelected: onItemSelected,
                ),
                NavItemWidget(
                  icon: Icons.point_of_sale,
                  title: LayoutStrings.sales,
                  screen: AppScreen.sales,
                  currentScreen: currentScreen,
                  onItemSelected: onItemSelected,
                ),
                NavItemWidget(
                  icon: Icons.shopping_cart,
                  title: LayoutStrings.purchases,
                  screen: AppScreen.purchases,
                  currentScreen: currentScreen,
                  onItemSelected: onItemSelected,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              LayoutStrings.logout,
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: onLogout,
          ),
          const SizedBox(height: Dimension.heightSizeBox20),
        ],
      ),
    );
  }
}
