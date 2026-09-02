import 'package:flutter/material.dart';

import '../cubit/purchases_cubit.dart';
import 'add_product_dialog.dart';

class ProductsSectionWidget extends StatelessWidget {
  final PurchasesCubit cubit;
  const ProductsSectionWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const Text('أصناف الفاتورة',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B))),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddProductDialog(cubit: cubit),
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('إضافة منتج'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          if (cubit.invoiceItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(
                  child: Text('لم يتم إضافة أصناف بعد',
                      style: TextStyle(color: Colors.grey, fontSize: 16))),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('اسم الصنف')),
                  DataColumn(label: Text('الكمية')),
                  DataColumn(label: Text('السعر')),
                  DataColumn(label: Text('الإجمالي')),
                  DataColumn(label: Text('حذف')),
                ],
                rows: List.generate(cubit.invoiceItems.length, (index) {
                  final item = cubit.invoiceItems[index];
                  return DataRow(cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(item['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(item['quantity'].toString(),
                        style: const TextStyle(
                            color: Color(0xFF0369A1),
                            fontWeight: FontWeight.bold))),
                    DataCell(Text('${item['unit_price']}')),
                    DataCell(Text('${item['total_price']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981)))),
                    DataCell(
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cubit.removeProduct(index)),
                    ),
                  ]);
                }),
              ),
            ),
        ],
      ),
    );
  }
}
