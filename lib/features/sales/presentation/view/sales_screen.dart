import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';
import '../widget/cart_list_widget.dart';
import '../widget/customer_info_widget.dart';
import '../widget/invoice_totals_widget.dart';
import '../widget/product_search_widget.dart';
import '../widget/sales_tabs_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    contactController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SalesCubit>(
      // 1. استدعاء initData لجلب كل البيانات دفعة واحدة
      create: (context) => getIt.get<SalesCubit>()..initData(),
      child: BlocListener<SalesCubit, SalesState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.submitError != current.submitError,
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('✅ تم حفظ الفاتورة بنجاح'),
                  backgroundColor: Colors.green),
            );
            contactController.clear();
            cityController.clear();
          } else if (state.submitError.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('❌ خطأ: ${state.submitError}'),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📦 إنشاء عملية بيع',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 20),
                const SalesTabsWidget(),
                const SizedBox(height: 20),
                // تمرير الكنترولرز
                CustomerInfoWidget(
                    contactController: contactController,
                    cityController: cityController),
                const SizedBox(height: 20),
                const ProductSearchWidget(),
                const SizedBox(height: 20),
                const CartListWidget(),
                const SizedBox(height: 20),
                InvoiceTotalsWidget(
                    contactController: contactController,
                    cityController: cityController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
