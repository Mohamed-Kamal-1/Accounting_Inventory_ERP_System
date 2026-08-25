import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../view_model/cubit/sales_history_cubit.dart';
import '../view_model/cubit/sales_history_state.dart';
import '../widgets/invoice_card_widget.dart';

// 💡 1. الغلاف المعماري الثابت (Stateless Wrapper) لحماية حالة الكيوبيت
class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SalesHistoryCubit>(
      create: (context) =>
          getIt.get<SalesHistoryCubit>()..fetchInvoices(isRefresh: true),
      child: const _SalesHistoryScreenContent(),
    );
  }
}

// 💡 2. واجهة المستخدم الفعلية التي تقبل إعادة البناء بدون تدمير الذاكرة
class _SalesHistoryScreenContent extends StatefulWidget {
  const _SalesHistoryScreenContent();

  @override
  State<_SalesHistoryScreenContent> createState() =>
      _SalesHistoryScreenContentState();
}

class _SalesHistoryScreenContentState
    extends State<_SalesHistoryScreenContent> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SalesHistoryCubit>().fetchInvoices();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  Future<void> _pickDateRange(BuildContext cubitContext) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      cubitContext
          .read<SalesHistoryCubit>()
          .setDateFilter(picked.start, picked.end);
    }
  }

  void _clearDateFilter(BuildContext cubitContext) {
    setState(() {
      _selectedDateRange = null;
    });
    cubitContext.read<SalesHistoryCubit>().clearDateFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        title: const Text(
          'سجل الفواتير والمبيعات',
          style:
              TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (cubitContext) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        cubitContext
                            .read<SalesHistoryCubit>()
                            .searchInvoices(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'ابحث باسم العميل أو رقم الفاتورة...',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => _pickDateRange(cubitContext),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _selectedDateRange == null
                            ? Colors.white
                            : Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedDateRange == null
                              ? Colors.transparent
                              : Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: _selectedDateRange == null
                            ? Colors.blueGrey
                            : Colors.blueAccent,
                      ),
                    ),
                  ),
                  if (_selectedDateRange != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _clearDateFilter(cubitContext),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.clear_rounded,
                            color: Colors.red.shade700),
                      ),
                    ),
                  ]
                ],
              );
            }),
          ),
          Expanded(
            child: BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
              builder: (context, state) {
                if (state.status == SalesHistoryStatus.loading &&
                    state.invoices.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == SalesHistoryStatus.failure &&
                    state.invoices.isEmpty) {
                  return Center(
                    child: Text(
                      'خطأ: ${state.errorMessage}',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                if (state.invoices.isEmpty) {
                  return const Center(
                    child: Text('لا توجد فواتير مطابقة للبحث أو التاريخ.',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.hasReachedMax
                      ? state.invoices.length
                      : state.invoices.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.invoices.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final invoice = state.invoices[index];
                    return InvoiceCardWidget(invoice: invoice);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
