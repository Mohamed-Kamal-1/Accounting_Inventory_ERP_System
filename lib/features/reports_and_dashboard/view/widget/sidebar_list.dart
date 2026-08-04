import 'package:accounting_desktop/features/reports_and_dashboard/view/widget/sidebar_listTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/menu_items.dart';

class SidebarList extends StatelessWidget {
  final List<SidebarItem> allowedItems;
  final StatefulNavigationShell navigationShell;

  const SidebarList(
      {super.key, required this.allowedItems, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: allowedItems.length,
        itemBuilder: (context, index) {
          final item = allowedItems[index];

          return SidebarListTile(
            key: ValueKey(item.route),
            item: item,
            navigationShell: navigationShell,
          );
        },
      ),
    );
  }
}
