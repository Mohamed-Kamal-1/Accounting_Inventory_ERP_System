import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

class InventoryStatsCards extends StatelessWidget {
  final List<ProductEntity> products;

  const InventoryStatsCards({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    int totalItems = products.length;
    int lowStock = products.where((p) => p.currentQuantity <= p.minQty).length;
    double stockValue = products.fold(
        0.0, (sum, p) => sum + (p.currentQuantity * p.purchasePrice));

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: [
        _buildCard('إجمالي الأصناف', totalItems.toString(), Colors.blue,
            Icons.inventory_2),
        _buildCard('أصناف منخفضة (نواقص)', lowStock.toString(), Colors.red,
            Icons.warning_amber_rounded),
        _buildCard(
            'قيمة المخزون (سعر الشراء)',
            '${stockValue.toStringAsFixed(2)} ج',
            Colors.green,
            Icons.monetization_on),
      ],
    );
  }

  Widget _buildCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: color, width: 5)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(icon, color: color, size: 36),
          ],
        ),
      ),
    );
  }
}
