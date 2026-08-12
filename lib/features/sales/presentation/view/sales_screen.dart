import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart'; // مكتبة الطباعة

import '../../../../core/di/di.dart';
import '../../domain/entities/sales_invoice_item_entity.dart';
import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';
import '../widget/cart_list_widget.dart';
import '../widget/customer_info_widget.dart';
import '../widget/invoice_totals_widget.dart';
import '../widget/pdf_invoice_generator.dart';
import '../widget/product_search_widget.dart';
import '../widget/sales_tabs_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    contactController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SalesCubit>(
      create: (context) => getIt.get<SalesCubit>()..initData(),
      child: Builder(
        builder: (context) {
          return BlocListener<SalesCubit, SalesState>(
            listenWhen: (previous, current) =>
                previous.isSuccess != current.isSuccess ||
                previous.submitError != current.submitError,
            listener: (context, state) async {
              if (state.isSuccess) {
                // 1. التقاط البيانات قبل تفريغ الشاشة
                final contactName = contactController.text;
                final mode = state.currentMode;
                final cart = List<SaleInvoiceItemEntity>.from(state.cart);
                final subTotal = state.subTotal;
                final discount = state.invoiceDiscountPercent;
                final grandTotal = state.grandTotal;
                final paidAmount = state.paidAmount;
                final remainingAmount = state.remainingAmount;

                // 2. تفريغ الحقول والكيوبيت فوراً لمنع التكرار والحماية
                contactController.clear();
                cityController.clear();
                context.read<SalesCubit>().resetCart();

                // 3. عرض نافذة منبثقة للطباعة (Dialog) بدلاً من الفتح التلقائي
                showDialog(
                  context: context,
                  barrierDismissible: false, // يمنع إغلاق النافذة بالنقر خارجها
                  builder: (dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 28),
                          SizedBox(width: 10),
                          Text('تم الحفظ بنجاح',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      content: const Text(
                          'تم تسجيل الفاتورة في النظام. هل ترغب في طباعتها الآن؟',
                          style: TextStyle(fontSize: 16)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                dialogContext); // إغلاق النافذة وبدء فاتورة جديدة
                          },
                          child: const Text('فاتورة جديدة (تخطي)',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(
                                dialogContext); // إغلاق النافذة ثم فتح الطباعة
                            await Printing.layoutPdf(
                              name:
                                  'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
                              onLayout: (format) async {
                                return await PdfInvoiceGenerator
                                    .generateInvoice(
                                  contactName: contactName,
                                  currentMode: mode,
                                  cart: cart,
                                  subTotal: subTotal,
                                  discount: discount,
                                  grandTotal: grandTotal,
                                  paidAmount: paidAmount,
                                  remainingAmount: remainingAmount,
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.print_rounded),
                          label: const Text('طباعة الفاتورة',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  },
                );
              } else if (state.submitError.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('❌ خطأ: ${state.submitError}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F7FA), // لون عصري ومريح للعين
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.point_of_sale_rounded,
                            color: Colors.blueAccent, size: 32),
                        const SizedBox(width: 12),
                        const Text(
                          'إنشاء عملية بيع',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B)),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final lastInvoice =
                                context.read<SalesCubit>().lastSavedInvoiceData;

                            if (lastInvoice == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'لا توجد فاتورة سابقة لطباعتها. قم بحفظ عملية بيع أولاً.'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            await Printing.layoutPdf(
                              name:
                                  'invoice_reprint_${DateTime.now().millisecondsSinceEpoch}.pdf',
                              onLayout: (format) async {
                                return await PdfInvoiceGenerator
                                    .generateInvoice(
                                  contactName: lastInvoice['contactName'],
                                  currentMode: lastInvoice['currentMode'],
                                  cart: lastInvoice['cart'],
                                  subTotal: lastInvoice['subTotal'],
                                  discount: lastInvoice['discount'],
                                  grandTotal: lastInvoice['grandTotal'],
                                  paidAmount: lastInvoice['paidAmount'],
                                  remainingAmount:
                                      lastInvoice['remainingAmount'],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueGrey,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: Colors.blueGrey, width: 0.5),
                            ),
                          ),
                          icon: const Icon(Icons.print_rounded, size: 20),
                          label: const Text('طباعة آخر فاتورة',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SalesTabsWidget(),
                    const SizedBox(height: 20),
                    CustomerInfoWidget(
                        contactController: contactController,
                        cityController: cityController),
                    const SizedBox(height: 20),
                    const ProductSearchWidget(),
                    const SizedBox(height: 20),
                    const CartListWidget(),
                    const SizedBox(height: 20),
                    InvoiceTotalsWidget(
                        contactController: contactController,
                        cityController: cityController),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
