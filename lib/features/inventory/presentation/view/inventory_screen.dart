import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ widgets/inventory_stats_cards.dart';
import '../ widgets/product_form_dialog.dart';
import '../../../../core/di/di.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';
import '../widgets/category_management_dialog.dart';
import '../widgets/inventory_action_bar.dart';
import '../widgets/products_table.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<InventoryBloc>()..add(LoadInventoryEvent()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventoryActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('✅ ${state.message}'),
                    backgroundColor: Colors.green),
              );
            } else if (state is InventoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('❌ ${state.message}'),
                    backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is InventoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InventoryLoaded) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '📦 إدارة المخزن والمستودعات',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50)),
                        ),
                        Row(
                          children: [
                            // 1. زر إضافة الأقسام (الذي ينقصك)
                            OutlinedButton.icon(
                              icon: const Icon(Icons.category),
                              label: const Text('إدارة الأقسام'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => CategoryManagementDialog(
                                      bloc: context.read<InventoryBloc>()),
                                );
                              },
                            ),
                            const SizedBox(width: 15),

                            // 2. زر إضافة الصنف الموجود عندك حالياً
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2ECC71)),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text('إضافة صنف جديد',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                if (state.categories.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('⚠️ يرجى إضافة قسم أولاً')),
                                  );
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (ctx) => ProductFormDialog(
                                    categories: state.categories,
                                    onSave: (prod, initialQty) {
                                      context.read<InventoryBloc>().add(
                                          AddProductEvent(prod, initialQty));
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InventoryStatsCards(products: state.allProducts),
                    const SizedBox(height: 20),
                    InventoryActionBar(state: state),
                    const SizedBox(height: 15),
                    Expanded(child: ProductsTable(state: state)),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
