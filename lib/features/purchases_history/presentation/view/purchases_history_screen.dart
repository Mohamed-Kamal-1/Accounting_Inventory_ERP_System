import 'package:accounting_desktop/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/purchases_history_entity.dart';
import '../cubit/purchases_history_cubit.dart';
import '../cubit/purchases_history_state.dart';

class PurchasesHistoryScreen extends StatelessWidget {
  const PurchasesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<PurchasesHistoryCubit>()..fetchHistory(),
      child: const PurchasesHistoryView(),
    );
  }
}

class PurchasesHistoryView extends StatelessWidget {
  const PurchasesHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('سجل فواتير المشتريات',
            style: TextStyle(
                color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF3B82F6)),
            onPressed: () =>
                context.read<PurchasesHistoryCubit>().fetchHistory(),
            tooltip: 'تحديث',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<PurchasesHistoryCubit, PurchasesHistoryState>(
        listener: (context, state) {
          if (state is PurchasesHistoryPdfLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()));
          } else if (state is PurchasesHistoryPdfSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('تم استخراج الـ PDF بنجاح'),
                backgroundColor: Colors.green));
          }
        },
        builder: (context, state) {
          final cubit = context.read<PurchasesHistoryCubit>();
          if (state is PurchasesHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PurchasesHistoryError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          } else if (cubit.currentInvoices.isNotEmpty) {
            return HistoryTableWidget(
                invoices: cubit.currentInvoices, cubit: cubit);
          }
          return const Center(
              child: Text('لا توجد فواتير مسجلة',
                  style: TextStyle(color: Colors.grey, fontSize: 16)));
        },
      ),
    );
  }
}

class HistoryTableWidget extends StatelessWidget {
  final List<PurchasesHistoryEntity> invoices;
  final PurchasesHistoryCubit cubit;

  const HistoryTableWidget(
      {super.key, required this.invoices, required this.cubit});

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    dataRowMinHeight: 65,
                    dataRowMaxHeight: 65,
                    columns: const [
                      DataColumn(label: Text('رقم الفاتورة')),
                      DataColumn(label: Text('التاريخ')),
                      DataColumn(label: Text('المورد')),
                      DataColumn(label: Text('الإجمالي'), numeric: true),
                      DataColumn(label: Text('المدفوع'), numeric: true),
                      DataColumn(label: Text('المتبقي'), numeric: true),
                      DataColumn(label: Center(child: Text('الحالة'))),
                      DataColumn(label: Center(child: Text('تصدير PDF'))),
                    ],
                    rows: List.generate(invoices.length, (index) {
                      final inv = invoices[index];
                      return DataRow(
                        color: WidgetStateProperty.resolveWith((_) =>
                            index.isEven
                                ? Colors.white
                                : const Color(0xFFF8FAFC).withOpacity(0.6)),
                        cells: [
                          DataCell(Text(inv.id.substring(0, 8).toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                          DataCell(Text(_formatDate(inv.createdAt))),
                          DataCell(Text(inv.supplierName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                          DataCell(Text('${inv.grandTotal} ج.م',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900))),
                          DataCell(Text('${inv.paidAmount} ج.م',
                              style: const TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold))),
                          DataCell(Text('${inv.remainingAmount} ج.م',
                              style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.bold))),
                          DataCell(Center(
                              child: StatusBadgeWidget(status: inv.status))),
                          DataCell(
                            Center(
                              child: IconButton(
                                icon: const Icon(Icons.picture_as_pdf,
                                    color: Color(0xFFEF4444)),
                                onPressed: () => cubit.exportInvoicePdf(inv),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBadgeWidget extends StatelessWidget {
  final String status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg =
        status == 'paid' ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);
    Color fg =
        status == 'paid' ? const Color(0xFF059669) : const Color(0xFFD97706);
    String txt = status == 'paid' ? 'مدفوع' : 'جزئي';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(txt,
          style:
              TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
