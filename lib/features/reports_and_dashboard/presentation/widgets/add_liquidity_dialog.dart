import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/reports_cubit.dart';

class AddLiquidityDialog extends StatefulWidget {
  const AddLiquidityDialog({super.key});

  @override
  State<AddLiquidityDialog> createState() => _AddLiquidityDialogState();
}

class _AddLiquidityDialogState extends State<AddLiquidityDialog> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final desc = _descController.text.trim();

      // إرسال البيانات للكيوبت
      context.read<ReportsCubit>().addManualDeposit(
            amount: amount,
            description: desc,
          );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'إضافة سيولة يدوية',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'المبلغ',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty)
                  return 'يرجى إدخال المبلغ';
                if (double.tryParse(val.trim()) == null)
                  return 'أدخل رقماً صحيحاً';
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'البيان',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.description),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? 'يرجى إدخال البيان'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child:
              const Text('حفظ العملية', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
