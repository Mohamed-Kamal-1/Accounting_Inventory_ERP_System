import 'package:accounting_desktop/features/sales/presentation/widget/paid_input_widget.dart';
import 'package:accounting_desktop/features/sales/presentation/widget/submit_invoice_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';
import 'amount_display_widget.dart';
import 'discount_input_widget.dart';

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
    final isMobile = MediaQuery.sizeOf(context).width < 600;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AmountDisplayWidget(
                            label: 'الإجمالي',
                            amount: state.subTotal,
                          ),
                          const SizedBox(height: 15),
                          DiscountInputWidget(controller: discountController),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AmountDisplayWidget(
                            label: 'الإجمالي',
                            amount: state.subTotal,
                          ),
                          DiscountInputWidget(controller: discountController),
                        ],
                      ),

                const Divider(height: 30),

                // الصف الثاني
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AmountDisplayWidget(
                            label: 'الصافي',
                            amount: state.grandTotal,
                            color: Colors.green,
                            fontSize: 20,
                          ),
                          const SizedBox(height: 15),
                          PaidInputWidget(controller: paidController),
                          const SizedBox(height: 15),
                          AmountDisplayWidget(
                            label: 'المتبقي',
                            amount: state.remainingAmount,
                            color: Colors.red,
                          ),
                        ],
                      )
                    : Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 15,
                        children: [
                          AmountDisplayWidget(
                            label: 'الصافي',
                            amount: state.grandTotal,
                            color: Colors.green,
                            fontSize: 20,
                          ),
                          PaidInputWidget(controller: paidController),
                          AmountDisplayWidget(
                            label: 'المتبقي',
                            amount: state.remainingAmount,
                            color: Colors.red,
                          ),
                        ],
                      ),

                const SizedBox(height: 25),

                // زر الحفظ
                SubmitInvoiceButton(
                  state: state,
                  contactName: widget.contactController.text,
                  city: widget.cityController.text,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
