import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class InvoiceTotalsWidget extends StatefulWidget {
  final TextEditingController contactController;
  final TextEditingController cityController;

  const InvoiceTotalsWidget({
    super.key,
    required this.contactController,
    required this.cityController,
  });

  @override
  State<InvoiceTotalsWidget> createState() => _InvoiceTotalsWidgetState();
}

class _InvoiceTotalsWidgetState extends State<InvoiceTotalsWidget> {
  final TextEditingController discountController =
      TextEditingController(text: '0');
  final TextEditingController paidController = TextEditingController(text: '0');

  @override
  void dispose() {
    discountController.dispose();
    paidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          discountController.text = '0';
          paidController.text = '0';
        }
      },
      builder: (context, state) {
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الإجمالي: ${state.subTotal} ج.م',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Text('خصم %: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              final discount = double.tryParse(val) ?? 0.0;
                              context
                                  .read<SalesCubit>()
                                  .updateDiscount(discount);
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الصافي: ${state.grandTotal} ج.م',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Text('المدفوع: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 110,
                          child: TextField(
                            controller: paidController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              final paid = double.tryParse(val) ?? 0.0;
                              context.read<SalesCubit>().updatePaidAmount(paid);
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8)),
                          ),
                        ),
                      ],
                    ),
                    Text('المتبقي: ${state.remainingAmount} ج.م',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (state.isSubmitting || state.cart.isEmpty)
                        ? null
                        : () {
                            context.read<SalesCubit>().submitInvoice(
                                  contactId: '',
                                  contactName: widget.contactController.text,
                                  city: widget.cityController.text,
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: state.isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('حفظ وإتمام عملية البيع ✅',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
