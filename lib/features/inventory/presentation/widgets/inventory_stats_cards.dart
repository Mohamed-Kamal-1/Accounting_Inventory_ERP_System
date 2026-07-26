import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

class InventoryStatsCards extends StatelessWidget {
  final List<ProductEntity> products;

  const InventoryStatsCards({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final totalProducts = products.length;
    final totalCategories = products.map((e) => e.categoryId).toSet().length;

    return Row(
      children: [
        _buildCard('إجمالي الأصناف', totalProducts.toString(),
            Icons.inventory_2, Colors.blue),
        const SizedBox(width: 15),
        _buildCard('الأقسام النشطة', totalCategories.toString(), Icons.category,
            Colors.orange),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
