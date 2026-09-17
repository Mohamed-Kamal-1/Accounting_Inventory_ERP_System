import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/reports_cubit.dart';
import 'add_liquidity_dialog.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final bool isMobile;
  const DashboardHeaderWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'لوحة التحكم والسيولة',
            style: TextStyle(
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final cubit = context.read<ReportsCubit>();
            showDialog(
              context: context,
              builder: (ctx) => BlocProvider.value(
                value: cubit,
                child: const AddLiquidityDialog(),
              ),
            );
          },
          icon: Icon(Icons.add_circle_outline, size: isMobile ? 18 : 22),
          label: Text(
            isMobile ? 'إيداع' : 'إيداع مبالغ إضافية',
            style: TextStyle(fontSize: isMobile ? 13 : 15),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 20,
              vertical: 12,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 2,
          ),
        ),
      ],
    );
  }
}
