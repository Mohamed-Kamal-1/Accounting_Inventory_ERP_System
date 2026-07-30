import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class SubmitInvoiceButton extends StatelessWidget {
  final SalesState state;
  final String contactName;
  final String city;

  const SubmitInvoiceButton({
    super.key,
    required this.state,
    required this.contactName,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (state.isSubmitting || state.cart.isEmpty)
            ? null
            : () {
                context.read<SalesCubit>().submitInvoice(
                      contactId: '',
                      contactName: contactName,
                      city: city,
                    );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2ECC71),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: state.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'حفظ وإتمام عملية البيع ✅',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
