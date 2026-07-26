import 'package:flutter/material.dart';

import '../../../../core/app_text/invoices_text/invoices_strings.dart';
import '../../../../core/dimensions/Dimension_app.dart';

class InvoiceFooter extends StatelessWidget {
  final double total;
  final VoidCallback onSubmit;

  const InvoiceFooter({
    super.key,
    required this.total,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${InvoicesStrings.invoiceTotal} ${total.toStringAsFixed(2)} ر.س',
          style: const TextStyle(
            fontSize: Dimension.size24,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimension.padding27,
              vertical: Dimension.padding19,
            ),
          ),
          onPressed: onSubmit,
          child: const Text(
            InvoicesStrings.saveInvoice,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
