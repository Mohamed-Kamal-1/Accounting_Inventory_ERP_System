import 'package:accounting_desktop/features/reports_and_dashboard/view/widget/sidebar_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/menu_items.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام read بدلاً من watch لمنع Rebuilds غير الضرورية من Cubit
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
      child: Column(
        children: [
          // const _SidebarHeader(),
          SidebarList(allowedItems: allowedItems),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
