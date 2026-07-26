import 'package:flutter/material.dart';

import '../../../../core/app_text/accounts_text/account_screen_text.dart';
import '../widgets/account_tab_content.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AccountsStrings.appBarTitle),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                  icon: Icon(Icons.people_alt),
                  text: AccountsStrings.customersTab),
              Tab(
                  icon: Icon(Icons.business_center),
                  text: AccountsStrings.suppliersTab),
              Tab(icon: Icon(Icons.badge), text: AccountsStrings.employeesTab),
              Tab(
                  icon: Icon(Icons.directions_run),
                  text: AccountsStrings.repsTab),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccountTabContent(type: 'customer'),
            AccountTabContent(type: 'supplier'),
            AccountTabContent(type: 'employee'),
            AccountTabContent(type: 'representative'),
          ],
        ),
      ),
    );
  }
}
