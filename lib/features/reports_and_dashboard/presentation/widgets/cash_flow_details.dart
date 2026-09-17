import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';

class CashFlowDetailsWidget extends StatefulWidget {
  const CashFlowDetailsWidget({super.key});

  @override
  State<CashFlowDetailsWidget> createState() => _CashFlowDetailsWidgetState();
}

class _CashFlowDetailsWidgetState extends State<CashFlowDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Color(0xFF64748B)),
              SizedBox(width: 10),
              Text(
                'تفاصيل حركة النقدية',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const Divider(height: 30, color: Color(0xFFE2E8F0)),

          // 💡 الاستماع للداتا من الكيوبت
          BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              if (state is ReportsLoading) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is ReportsLoaded) {
                final transactions = state.transactions;

                if (transactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: [
                          Icon(Icons.money_off_csred_rounded,
                              size: 60, color: Colors.grey.shade300),
                          const SizedBox(height: 15),
                          Text('لا توجد حركات نقدية في هذه الفترة',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isIncome = tx.isIncome;

                    // تنسيق التاريخ والوقت
                    final dateStr =
                        "${tx.createdAt.year}-${tx.createdAt.month.toString().padLeft(2, '0')}-${tx.createdAt.day.toString().padLeft(2, '0')}";
                    final timeStr =
                        "${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}";

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? const Color(0xFFD1FAE5)
                                  : const Color(0xFFFEE2E2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: isIncome
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.description.isNotEmpty
                                      ? tx.description
                                      : 'حركة نقدية',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$dateStr - $timeStr',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isIncome
                                ? '+ ${tx.amount} ج.م'
                                : '- ${tx.amount} ج.م',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isIncome
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
