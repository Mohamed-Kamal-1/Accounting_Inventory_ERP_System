import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';

class InventoryActionBar extends StatelessWidget {
  final InventoryLoaded state;

  const InventoryActionBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // حقل البحث
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (query) {
                  context.read<InventoryBloc>().add(SearchProductsEvent(query));
                },
                decoration: const InputDecoration(
                  hintText: 'ابحث عن صنف بالاسم أو الكود...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 15),

            // القائمة المنسدلة للفلترة بالأقسام
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: state.selectedCategoryId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(
                      value: 'all', child: Text('جميع الأقسام')),
                  ...state.categories.map((c) =>
                      DropdownMenuItem(value: c.id, child: Text(c.name))),
                ],
                onChanged: (catId) {
                  if (catId != null) {
                    context
                        .read<InventoryBloc>()
                        .add(FilterByCategoryEvent(catId));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
