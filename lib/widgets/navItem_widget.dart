import 'package:flutter/material.dart';

import '../ widgets/app_screen.dart';
import '../core/dimensions/Dimension_app.dart';

class NavItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final AppScreen screen;
  final AppScreen currentScreen;
  final Function(AppScreen) onItemSelected;

  const NavItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.screen,
    required this.currentScreen,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentScreen == screen;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Dimension.padding12, vertical: Dimension.padding4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(Dimension.circular12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => onItemSelected(screen),
      ),
    );
  }
}
