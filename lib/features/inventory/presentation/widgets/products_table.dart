import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';

class ProductsTable extends StatelessWidget {
  final InventoryLoaded state;

  const ProductsTable({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.filteredProducts.isEmpty) {
      return const Center(
        child: Text('لا توجد أصناف تطابق البحث',
            style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        itemCount: state.filteredProducts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = state.filteredProducts[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF3498DB),
              child: Icon(Icons.inventory, color: Colors.white, size: 20),
            ),
            title: Text(product.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                'سعر الشراء: ${product.purchasePrice} ج.م  |  سعر البيع: ${product.salePrice} ج.م'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                context
                    .read<InventoryBloc>()
                    .add(DeleteProductEvent(product.id));
              },
            ),
          );
        },
      ),
    );
  }
}
