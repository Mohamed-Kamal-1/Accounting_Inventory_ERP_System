import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/entities/sales_invoice_item_entity.dart';

class PdfInvoiceGenerator {
  static Future<Uint8List> generateInvoice({
    required String contactName,
    required String currentMode,
    required List<SaleInvoiceItemEntity> cart,
    required double subTotal,
    required double discount,
    required double grandTotal,
    required double paidAmount,
    required double remainingAmount,
  }) async {
    final pdf = pw.Document();

    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final modeTitle = currentMode == 'salesman'
        ? 'بيان تسليم عهدة'
        : (currentMode == 'supplier' ? 'فاتورة مرتجع مورد' : 'فاتورة مبيعات');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40), // هوامش متزنة
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- Header ---
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('نظام إدارة المخازن والمبيعات',
                            style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey900)),
                        pw.SizedBox(height: 4),
                        pw.Text(
                            'التاريخ: ${DateTime.now().toString().substring(0, 16)}',
                            style: const pw.TextStyle(
                                fontSize: 12, color: PdfColors.grey700)),
                      ],
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blueGrey50,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.blueGrey200),
                    ),
                    child: pw.Text(modeTitle,
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey900)),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 10),

              // --- Client Info ---
              pw.Text('بيانات الطرف الثاني:',
                  style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700)),
              pw.SizedBox(height: 4),
              pw.Text('الاسم: $contactName',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              // --- Table ---
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 1),
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 12),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                cellStyle: const pw.TextStyle(fontSize: 12),
                cellPadding:
                    const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                cellAlignment: pw.Alignment.center,
                columnWidths: {
                  0: const pw.FixedColumnWidth(40), // م
                  1: const pw.FlexColumnWidth(3), // الصنف
                  2: const pw.FlexColumnWidth(1), // الكمية
                  3: const pw.FlexColumnWidth(1.5), // السعر
                  4: const pw.FlexColumnWidth(1.5), // الإجمالي
                },
                data: [
                  ['م', 'اسم الصنف', 'الكمية', 'سعر الوحدة', 'الإجمالي'],
                  ...cart.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    SaleInvoiceItemEntity item = entry.value;
                    return [
                      index.toString(),
                      item.productName,
                      item.quantity.toString(),
                      item.unitPrice.toStringAsFixed(2),
                      item.total.toStringAsFixed(2),
                    ];
                  }),
                ],
              ),
              pw.SizedBox(height: 20),

              // --- Totals Section (محاذاة صارمة لليسار) ---
              pw.Row(
                mainAxisAlignment:
                    pw.MainAxisAlignment.end, // دفع الإجماليات لليسار
                children: [
                  pw.Container(
                    width: 260,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(6),
                      color: PdfColors.grey50,
                    ),
                    child: pw.Column(
                      children: [
                        _buildSummaryRow('الإجمالي الفرعي:', subTotal),
                        _buildSummaryRow('الخصم:', discount, isDiscount: true),
                        pw.Divider(color: PdfColors.grey400),
                        _buildSummaryRow('الصافي النهائي:', grandTotal,
                            isBold: true),
                        if (currentMode != 'salesman') ...[
                          pw.SizedBox(height: 8),
                          _buildSummaryRow('المدفوع:', paidAmount,
                              color: PdfColors.green700),
                          _buildSummaryRow('المتبقي (آجل):', remainingAmount,
                              color: PdfColors.red700),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // --- Signatures ---
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('توقيع المستلم: ........................',
                      style: const pw.TextStyle(fontSize: 12)),
                  pw.Text('توقيع الكاشير/المسئول: ........................',
                      style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSummaryRow(String label, double value,
      {bool isBold = false, bool isDiscount = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(
            isDiscount
                ? '% ${value.toStringAsFixed(2)}'
                : '${value.toStringAsFixed(2)} ج.م',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color ?? PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
