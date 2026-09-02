import 'package:accounting_desktop/core/routes/app_routes.dart';
import 'package:accounting_desktop/features/purchases/presentation/widget/products_section_widget.dart';
import 'package:accounting_desktop/features/purchases/presentation/widget/summary_section_widget.dart';
import 'package:accounting_desktop/features/purchases/presentation/widget/supplier_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/purchase_state.dart';
import '../cubit/purchases_cubit.dart';
import '../view/add_purchase_screen.dart';

class AddPurchaseView extends StatefulWidget {
  const AddPurchaseView({super.key});

  @override
  State<AddPurchaseView> createState() => _AddPurchaseViewState();
}

class _AddPurchaseViewState extends State<AddPurchaseView> {
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchasesCubit>().loadInitialData();
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchasesCubit>();
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('إنشاء فاتورة مشتريات',
            style: TextStyle(
                color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        actions: [
          TextButton.icon(
            onPressed: () => context.go(AppRoute.purchasesHistory),
            icon: const Icon(Icons.history, color: Color(0xFF3B82F6)),
            label: const Text('سجل الفواتير',
                style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: BlocConsumer<PurchasesCubit, PurchasesState>(
        listener: (context, state) {
          if (state is PurchasesSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessActionDialog(cubit: cubit),
            );
          } else if (state is PurchasesError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF4444)));
          }
        },
        builder: (context, state) {
          if (state is PurchasesLoading && cubit.allProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (isDesktop) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: ProductsSectionWidget(cubit: cubit)),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 3,
                    child: SummaryAndSupplierSectionWidget(
                      cubit: cubit,
                      discountController: _discountController,
                      paidController: _paidController,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SupplierSectionWidget(cubit: cubit),
                  const SizedBox(height: 16),
                  ProductsSectionWidget(cubit: cubit),
                  const SizedBox(height: 16),
                  SummarySectionWidget(
                    cubit: cubit,
                    discountController: _discountController,
                    paidController: _paidController,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
