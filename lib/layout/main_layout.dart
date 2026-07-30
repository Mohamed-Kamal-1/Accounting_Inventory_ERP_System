import 'package:flutter/material.dart';

import '../features/reports_and_dashboard/view/widget/app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;
    return Scaffold(
      drawer: (isMobile)
          ? Drawer(
              child: AppSidebar(),
            )
          : null,
      appBar: (isMobile) ? AppBar() : null,
      backgroundColor: const Color(0xFFF4F7F6),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !isMobile,
            child: const SizedBox(
              width: 250,
              child: AppSidebar(),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF4F7F6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
