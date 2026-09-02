import 'package:accounting_desktop/layout/side_bar/sidebar_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/menu_items.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';

class AppSidebar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppSidebar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;

    if (authState is! AuthSuccess) {
      return const SizedBox(
        width: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final String userRole = authState.user.role;
    final allowedItems =
        appMenuItems.where((item) => item.roles.contains(userRole)).toList();

    return Material(
      color: Theme.of(context).cardColor,
      child: Drawer(
        child: Column(
          children: [
            SidebarList(
              allowedItems: allowedItems,
              navigationShell: navigationShell,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: GestureDetector(
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.read<AuthCubit>().logOut();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
