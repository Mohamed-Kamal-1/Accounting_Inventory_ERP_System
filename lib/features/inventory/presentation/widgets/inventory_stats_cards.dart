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
        StatCardWidget(
          title: 'إجمالي الأصناف',
          value: totalProducts.toString(),
          icon: Icons.inventory_2,
          color: Colors.blue,
        ),
        const SizedBox(width: 15),
        StatCardWidget(
          title: 'الأقسام النشطة',
          value: totalCategories.toString(),
          icon: Icons.category,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
