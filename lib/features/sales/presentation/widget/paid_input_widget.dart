import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';

class PaidInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const PaidInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('المدفوع: ', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 110,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final paid = double.tryParse(val) ?? 0.0;
              context.read<SalesCubit>().updatePaidAmount(paid);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
