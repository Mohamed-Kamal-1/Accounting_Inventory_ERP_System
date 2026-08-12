import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class InvoiceTotalsWidget extends StatelessWidget {
  final TextEditingController contactController;
  final TextEditingController cityController;

  const InvoiceTotalsWidget({
    super.key,
    required this.contactController,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        final isSalesman = state.currentMode == 'salesman';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSalesman)
                Row(
                  children: [
                    const Text('خصم %:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: (value) {
                          final discount = double.tryParse(value) ?? 0.0;
                          context.read<SalesCubit>().updateDiscount(discount);
                        },
                      ),
                    ),
                    const Spacer(),
                    Text('الإجمالي: ${state.subTotal.toStringAsFixed(2)} ج.م',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              if (!isSalesman) const SizedBox(height: 16),
              Row(
                children: [
                  Text('الصافي: ${state.grandTotal.toStringAsFixed(2)} ج.م',
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const Spacer(),
                  if (!isSalesman) ...[
                    const Text('المدفوع:'),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: (value) {
                          final paid = double.tryParse(value) ?? 0.0;
                          context.read<SalesCubit>().updatePaidAmount(paid);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                        'المتبقي: ${state.remainingAmount.toStringAsFixed(2)} ج.م',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ] else ...[
                    const Text('📦 معاملة نقل عهدة (لا توجد حسابات مالية)',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          context.read<SalesCubit>().submitInvoice(
                                contactId: state.selectedContactId,
                                contactName: contactController.text,
                                city: cityController.text,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_box, color: Colors.white),
                  label: Text(
                    state.isSubmitting
                        ? 'جاري الحفظ...'
                        : 'حفظ وإتمام عملية البيع',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
