import 'package:flutter/material.dart';

import '../../../../core/app_text/invoices_text/invoices_strings.dart';
import '../../domain/entities/invoice_item_entity.dart';

class InvoiceItemsList extends StatelessWidget {
  final List<InvoiceItemEntity> items;

  const InvoiceItemsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            title: Text(item.productName),
            subtitle: Text(
              '${InvoicesStrings.quantity}: ${item.quantity} | ${InvoicesStrings.price}: ${item.price.toStringAsFixed(2)}',
            ),
            trailing: Text(
              '${item.total.toStringAsFixed(2)} ر.س',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
