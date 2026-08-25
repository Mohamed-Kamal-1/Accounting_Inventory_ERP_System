import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';
import '../widgets/category_management_dialog.dart';
import '../widgets/inventory_action_bar.dart';
import '../widgets/inventory_stats_cards.dart';
import '../widgets/product_form_dialog.dart';
import '../widgets/products_table.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;

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
                padding: EdgeInsets.all(isMobile ? 12.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (!isMobile)
                          const Text(
                            '📦 إدارة المخزن والمستودعات',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50)),
                          ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Builder(builder: (context) {
                              final authState = context.read<AuthCubit>().state;
                              bool isAdmin = false;

                              if (authState is AuthSuccess) {
                                isAdmin = authState.user.role == 'admin';
                              }

                              if (!isAdmin) return const SizedBox.shrink();

                              return OutlinedButton.icon(
                                icon: const Icon(Icons.category, size: 18),
                                label: const Text('إدارة الأقسام'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => CategoryManagementDialog(
                                        bloc: context.read<InventoryBloc>()),
                                  );
                                },
                              );
                            }),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2ECC71)),
                              icon: const Icon(Icons.add,
                                  color: Colors.white, size: 18),
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
                    const SizedBox(height: 16),
                    InventoryStatsCards(products: state.allProducts),
                    const SizedBox(height: 16),
                    InventoryActionBar(state: state),
                    const SizedBox(height: 12),
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
