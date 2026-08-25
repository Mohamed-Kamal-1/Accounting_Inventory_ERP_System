import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../sales/domain/entities/sales_invoice_item_entity.dart';
import '../../../sales/presentation/widget/pdf_invoice_generator.dart';
import '../../domain/entities/invoice_header_entity.dart';
import '../view_model/cubit/sales_history_cubit.dart';
import '../view_model/cubit/sales_history_state.dart';

class InvoiceDetailsModalWidget extends StatelessWidget {
  final InvoiceHeaderEntity invoice;

  const InvoiceDetailsModalWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
          builder: (context, state) {
            if (state.detailsStatus == InvoiceDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.detailsStatus == InvoiceDetailsStatus.failure) {
              return Center(
                child: Text(
                  'خطأ: ${state.detailsErrorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final details = state.selectedInvoiceDetails;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تفاصيل الفاتورة',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: details.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = details[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'الكمية: ${item.quantity} × ${item.unitPrice} ج.م'),
                        trailing: Text(
                          '${item.totalPrice.toStringAsFixed(2)} ج.م',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // التعيين الصحيح للكيان بناءً على التحديث الأخير
                        final cartForPdf = details
                            .map((e) => SaleInvoiceItemEntity(
                                  productId: e.productId,
                                  productName: e.productName,
                                  unitPrice: e.unitPrice,
                                  quantity: e.quantity,
                                  itemDiscountPercent:
                                      0.0, // القيمة الافتراضية للخصم لعدم توفرها هنا
                                  total: e.totalPrice,
                                ))
                            .toList();

                        await Printing.layoutPdf(
                          name: 'reprint_${invoice.id.substring(0, 8)}.pdf',
                          onLayout: (format) async {
                            return await PdfInvoiceGenerator.generateInvoice(
                              contactName: invoice.contactName,
                              currentMode: invoice.invoiceType,
                              cart: cartForPdf,
                              subTotal: invoice.subTotal,
                              discount: invoice.discount,
                              grandTotal: invoice.grandTotal,
                              paidAmount: invoice.paidAmount,
                              remainingAmount: invoice.remainingAmount,
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.print_rounded),
                      label: const Text(
                        'إعادة طباعة الفاتورة',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
