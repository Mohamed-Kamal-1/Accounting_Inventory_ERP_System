import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/menu_items.dart';

class SidebarListTile extends StatelessWidget {
  final SidebarItem item;

  const SidebarListTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // كل عنصر يراقب المسار بنفسه
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
          context.go(item.route);
        }
      },
    );
  }
}
