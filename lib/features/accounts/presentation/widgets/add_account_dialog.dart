import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_text/accounts_text/account_screen_text.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../../domain/entities/account_entity.dart';
import '../view_model/cubit/Account_Cubit.dart';

class AddAccountDialog extends StatefulWidget {
  final String type;

  const AddAccountDialog({
    super.key,
    required this.type,
  });

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  void _onSave(BuildContext context) {
    if (_nameController.text.trim().isNotEmpty) {
      final newAccount = AccountEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        type: widget.type,
      );

      context.read<AccountCubit>().createAccount(newAccount);
      Navigator.of(context).pop();
    }
  }

  String _getDialogTitle() {
    switch (widget.type) {
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
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _getDialogTitle(),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: AccountsStrings.name,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Dimension.heightSizeBox12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: AccountsStrings.phone,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: Dimension.heightSizeBox12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: AccountsStrings.city,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AccountsStrings.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _onSave(context),
          child: const Text(AccountsStrings.save),
        ),
      ],
    );
  }
}
