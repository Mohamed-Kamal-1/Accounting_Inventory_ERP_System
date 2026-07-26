import 'package:accounting_desktop/features/reports_and_dashboard/view/widget/sidebar_listTile.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/menu_items.dart';

class SidebarList extends StatelessWidget {
  final List<SidebarItem> allowedItems;

  const SidebarList({
    super.key,
    required this.allowedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: allowedItems.length,
        itemBuilder: (context, index) {
          final item = allowedItems[index];

          // استخدام const أو إبقاء الـ Widget ثابته بدون اعتماد على متغيرات خارجيه
          return SidebarListTile(
            key: ValueKey(item.route),
            item: item,
          );
        },
      ),
    );
  }
}
