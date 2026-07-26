import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_text/accounts_text/account_screen_text.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../view_model/cubit/Account_Cubit.dart';
import 'add_account_dialog.dart';

class AccountsActionBar extends StatelessWidget {
  final String type;

  const AccountsActionBar({
    super.key,
    required this.type,
  });

  String _getSearchHint() {
    switch (type) {
      case 'customer':
        return AccountsStrings.searchCustomer;
      case 'supplier':
        return AccountsStrings.searchSupplier;
      case 'employee':
        return AccountsStrings.searchEmployee;
      case 'representative':
        return AccountsStrings.searchRep;
      default:
        return AccountsStrings.searchDefault;
    }
  }

  String _getButtonLabel() {
    switch (type) {
      case 'customer':
        return AccountsStrings.addCustomer;
      case 'supplier':
        return AccountsStrings.addSupplier;
      case 'employee':
        return AccountsStrings.addEmployee;
      case 'representative':
        return AccountsStrings.addRep;
      default:
        return AccountsStrings.addDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              context.read<AccountCubit>().search(value, type);
            },
            decoration: InputDecoration(
              hintText: _getSearchHint(),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimension.circular12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimension.spacing20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimension.padding24,
              vertical: Dimension.padding16,
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<AccountCubit>(),
                child: AddAccountDialog(type: type),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: Text(_getButtonLabel()),
        ),
      ],
    );
  }
}
