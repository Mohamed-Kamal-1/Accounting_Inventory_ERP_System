import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';

class DiscountInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const DiscountInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('خصم %: ', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final discount = double.tryParse(val) ?? 0.0;
              context.read<SalesCubit>().updateDiscount(discount);
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
