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
    final isMobile = MediaQuery.sizeOf(context).width < 650;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            // حقل البحث
            if (isMobile)
              TextField(
                onChanged: (query) {
                  context.read<InventoryBloc>().add(SearchProductsEvent(query));
                },
                decoration: const InputDecoration(
                  hintText: 'ابحث عن صنف بالاسم أو الكود...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              )
            else
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (query) {
                    context
                        .read<InventoryBloc>()
                        .add(SearchProductsEvent(query));
                  },
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن صنف بالاسم أو الكود...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              ),

            SizedBox(width: isMobile ? 0 : 12, height: isMobile ? 10 : 0),

            // القائمة المنسدلة
            if (isMobile)
              DropdownButtonFormField<String>(
                value: state.selectedCategoryId,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              )
            else
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: state.selectedCategoryId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
