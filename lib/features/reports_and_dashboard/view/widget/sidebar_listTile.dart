import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/menu_items.dart';

class SidebarListTile extends StatelessWidget {
  final SidebarItem item;
  final StatefulNavigationShell navigationShell; // استقبال

  const SidebarListTile({
    super.key,
    required this.item,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isActive = currentRoute == item.route;

    return ListTile(
      leading: Icon(
        item.icon,
        color: isActive ? Colors.blue : Colors.grey,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.black87,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: Colors.blue.withValues(alpha: 0.1),
      onTap: () {
        if (!isActive) {
          // التنقل الصحيح الذي يحافظ على حالة الشاشات
          navigationShell.goBranch(
            item.branchIndex,
            // هذا السطر يمنع إعادة تشغيل الفرع إذا ضغطت عليه مرة أخرى
            initialLocation: item.branchIndex == navigationShell.currentIndex,
          );
        }
      },
    );
  }
}
