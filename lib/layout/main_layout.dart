import 'package:flutter/material.dart';

import '../../features/reports_and_dashboard/view/widget/app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 250,
            child: AppSidebar(), // الآن يعمل كـ Const بدون مشاكل
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
