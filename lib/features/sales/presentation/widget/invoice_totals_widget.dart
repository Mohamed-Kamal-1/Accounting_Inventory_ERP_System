import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class InvoiceTotalsWidget extends StatelessWidget {
  final TextEditingController contactController;
  final TextEditingController cityController;

  const InvoiceTotalsWidget({
    super.key,
    required this.contactController,
    required this.cityController,
  });

  InputDecoration _smallInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        final isSalesman = state.currentMode == 'salesman';

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSalesman)
                Row(
                  children: [
                    const Text('خصم % :',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: _smallInputDecoration(),
                        onChanged: (value) {
                          // إرسال قيمة الخصم للـ Cubit
                          final discount = double.tryParse(value) ?? 0.0;
                          context.read<SalesCubit>().updateDiscount(discount);
                        },
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('الإجمالي',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('${state.subTotal.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87)),
                      ],
                    )
                  ],
                ),
              if (!isSalesman)
                const Divider(height: 30, color: Color(0xFFF1F5F9)),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الصافي النهائي',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Text('${state.grandTotal.toStringAsFixed(2)} ج.م',
                          style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w900,
                              fontSize: 24)),
                    ],
                  ),
                  const Spacer(),
                  if (!isSalesman) ...[
                    const Text('المدفوع :',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: _smallInputDecoration(),
                        onChanged: (value) {
                          // إرسال المبلغ المدفوع للـ Cubit (والذي يتكفل بالتحقق المالي)
                          final paid = double.tryParse(value) ?? 0.0;
                          context.read<SalesCubit>().updatePaidAmount(paid);
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('المتبقي (آجل)',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('${state.remainingAmount.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Text('معاملة نقل عهدة (لا توجد حسابات مالية)',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  // تعطيل الضغط في حالة التحميل أو جاري الإرسال لمنع التكرار
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          // استدعاء دالة تقديم الفاتورة بالبيانات المجمعة
                          context.read<SalesCubit>().submitInvoice(
                                contactId: state.selectedContactId,
                                contactName: contactController.text,
                                city: cityController.text,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: state.isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline_rounded,
                          size: 26),
                  label: Text(
                    state.isSubmitting
                        ? 'جاري الحفظ...'
                        : 'حفظ وإتمام عملية البيع',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
