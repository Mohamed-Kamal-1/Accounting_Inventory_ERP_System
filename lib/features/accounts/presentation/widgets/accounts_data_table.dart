import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_text/accounts_text/account_screen_text.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../../domain/entities/account_entity.dart';
import '../view_model/cubit/Account_Cubit.dart';

class AccountsDataTable extends StatelessWidget {
  final List<AccountEntity> data;
  final String type;

  const AccountsDataTable({
    super.key,
    required this.data,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimension.circular12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primaryContainer),
                horizontalMargin: Dimension.padding20,
                columnSpacing: Dimension.spacing24,
                columns: const [
                  DataColumn(label: Text(AccountsStrings.name)),
                  DataColumn(label: Text(AccountsStrings.city)),
                  DataColumn(label: Text(AccountsStrings.phone)),
                  DataColumn(label: Text(AccountsStrings.actions)),
                ],
                rows: data.map((account) {
                  return DataRow(
                    cells: [
                      DataCell(Text(account.name)),
                      DataCell(Text(account.city)),
                      DataCell(Text(account.phone)),
                      DataCell(
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            context
                                .read<AccountCubit>()
                                .removeAccount(account.id, type);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
