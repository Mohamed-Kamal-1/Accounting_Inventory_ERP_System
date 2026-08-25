import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/reports_and_dashboard/view/widget/app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

  _getAppBarTitle(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return Text('لوحة القيادة (الرئيسية)');
      case 1:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.point_of_sale_rounded,
                color: Colors.blueAccent, size: 32),
            const SizedBox(width: 12),
            const Text(
              'إنشاء عملية بيع',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B)),
            ),
          ],
        );
      case 2:
        return Text('جهات الاتصال');
      case 3:
        return Text('المخزون');

      default:
        return Text('لنظام المحاسبي');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;
    return Scaffold(
      drawer: (isMobile)
          ? Drawer(
              child: AppSidebar(
                navigationShell: navigationShell,
              ),
            )
          : null,
      appBar: (isMobile)
          ? AppBar(
              title: _getAppBarTitle(navigationShell.currentIndex),
              centerTitle: true,
            )
          : null,
      backgroundColor: const Color(0xFFF4F7F6),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !isMobile,
            child: SizedBox(
              width: 250,
              child: AppSidebar(
                navigationShell: navigationShell,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF4F7F6),
              child: navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}
