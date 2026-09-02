import 'package:accounting_desktop/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/purchases_cubit.dart';
import '../widget/add_purchase_view.dart';
import '../widget/summary_section_widget.dart';
import '../widget/supplier_section_widget.dart';

class AddPurchaseScreen extends StatelessWidget {
  const AddPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<PurchasesCubit>()..loadInitialData(),
      child: const AddPurchaseView(),
    );
  }
}

class SummaryAndSupplierSectionWidget extends StatelessWidget {
  final PurchasesCubit cubit;
  final TextEditingController discountController;
  final TextEditingController paidController;

  const SummaryAndSupplierSectionWidget({
    super.key,
    required this.cubit,
    required this.discountController,
    required this.paidController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SupplierSectionWidget(cubit: cubit),
        const SizedBox(height: 24),
        SummarySectionWidget(
          cubit: cubit,
          discountController: discountController,
          paidController: paidController,
        ),
      ],
    );
  }
}

class SummaryRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isAlert;

  const SummaryRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
        Text('$value ج.م',
            style: TextStyle(
                fontSize: isTotal ? 20 : 16,
                fontWeight: FontWeight.bold,
                color: isTotal
                    ? const Color(0xFF10B981)
                    : (isAlert ? Colors.red : Colors.black87))),
      ],
    );
  }
}

class SuccessActionDialog extends StatelessWidget {
  final PurchasesCubit cubit;
  const SuccessActionDialog({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Column(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 60),
          SizedBox(height: 10),
          Text('تم حفظ الفاتورة بنجاح!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      content: const Text('ماذا تريد أن تفعل الآن؟',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تجهيز قسم الطباعة...')));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white),
          icon: const Icon(Icons.print),
          label: const Text('طباعة'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            cubit.resetInvoice();
          },
          child: const Text('تخطي الآن',
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
