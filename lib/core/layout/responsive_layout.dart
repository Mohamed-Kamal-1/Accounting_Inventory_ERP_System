import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.desktopBreakpoint) {
          return desktop;
        } else if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          // إذا لم يتم تمرير تصميم خاص بالتابلت، استخدم الموبايل
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
