import 'package:flutter/material.dart';

import '../cubit/purchase_state.dart';
import '../cubit/purchases_cubit.dart';
import '../view/add_purchase_screen.dart';

class SummarySectionWidget extends StatelessWidget {
  final PurchasesCubit cubit;
  final TextEditingController discountController;
  final TextEditingController paidController;

  const SummarySectionWidget({
    super.key,
    required this.cubit,
    required this.discountController,
    required this.paidController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          SummaryRowWidget(
              label: 'الإجمالي الفرعي:',
              value: cubit.subTotal.toStringAsFixed(2)),
          const SizedBox(height: 15),
          TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'الخصم', border: OutlineInputBorder()),
              onChanged: (val) =>
                  cubit.updateDiscount(double.tryParse(val) ?? 0.0)),
          const SizedBox(height: 15),
          SummaryRowWidget(
              label: 'الصافي النهائي:',
              value: cubit.grandTotal.toStringAsFixed(2),
              isTotal: true),
          const SizedBox(height: 15),
          TextField(
              controller: paidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'المدفوع نقدياً', border: OutlineInputBorder()),
              onChanged: (val) =>
                  cubit.updatePaidAmount(double.tryParse(val) ?? 0.0)),
          const SizedBox(height: 15),
          SummaryRowWidget(
              label: 'المتبقي (آجل):',
              value: cubit.remainingAmount.toStringAsFixed(2),
              isAlert: cubit.remainingAmount > 0),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: cubit.state is PurchasesLoading
                  ? null
                  : () => cubit.saveInvoice(),
              icon: const Icon(Icons.save),
              label: const Text('حفظ واعتماد الفاتورة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
