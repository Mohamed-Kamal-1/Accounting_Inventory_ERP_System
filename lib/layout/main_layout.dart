import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/reports_and_dashboard/view/widget/app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

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
      appBar: (isMobile) ? AppBar() : null,
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
