import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class SalesTabsWidget extends StatelessWidget {
  const SalesTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      buildWhen: (previous, current) =>
          previous.currentMode != current.currentMode,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              _buildTab(context, 'تاجر (عميل)', 'merchant', Icons.store,
                  state.currentMode),
              const SizedBox(width: 8),
              _buildTab(context, 'مندوب', 'salesman', Icons.local_shipping,
                  state.currentMode),
              const SizedBox(width: 8),
              _buildTab(context, 'مورد', 'supplier', Icons.factory,
                  state.currentMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(BuildContext context, String title, String mode,
      IconData icon, String currentMode) {
    final isActive = currentMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => context.read<SalesCubit>().changeMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3498DB) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isActive ? Colors.white : Colors.grey.shade700,
                  size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
