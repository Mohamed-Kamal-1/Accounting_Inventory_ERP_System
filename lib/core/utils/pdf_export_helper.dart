import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportHelper {
  static Future<void> generateAndSaveInvoice({
    required String invoiceId,
    required String date,
    required String supplierName,
    required List<Map<String, dynamic>> items,
    required double subTotal,
    required double discount,
    required double grandTotal,
    required double paid,
    required double remaining,
  }) async {
    // تحميل خطوط تدعم العربية بوزن عادى وعريض
    final fontRegular = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        // 💡 إجبار الصفحة بالكامل على الاتجاه من اليمين لليسار
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData(
          defaultTextStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. الهيدر
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('فاتورة مشتريات',
                      style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 24,
                          color: PdfColors.blue800)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('رقم الفاتورة: $invoiceId',
                          style: pw.TextStyle(font: fontBold)),
                      pw.Text('التاريخ: ${date.split('T').first}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // 2. بيانات المورد
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Row(
                  children: [
                    pw.Text('اسم المورد: ',
                        style: pw.TextStyle(font: fontBold)),
                    pw.Text(supplierName),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // 3. جدول المنتجات
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(color: PdfColors.grey400),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blue50),
                headerStyle:
                    pw.TextStyle(font: fontBold, color: PdfColors.blue900),
                cellStyle: pw.TextStyle(font: fontRegular),
                cellAlignment: pw.Alignment.center,
                headers: ['م', 'اسم الصنف', 'الكمية', 'السعر', 'الإجمالي'],
                data: List.generate(items.length, (index) {
                  final item = items[index];
                  return [
                    '${index + 1}',
                    item['name'].toString(),
                    item['quantity'].toString(),
                    '${item['unit_price']}',
                    '${item['total_price']}',
                  ];
                }),
              ),
              pw.SizedBox(height: 20),

              // 4. ملخص الحسابات
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 250,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Column(
                      children: [
                        _buildSummaryRow(
                            'الإجمالي الفرعي:', subTotal, fontBold),
                        pw.Divider(color: PdfColors.grey300),
                        _buildSummaryRow('الخصم:', discount, fontBold),
                        pw.Divider(color: PdfColors.grey300),
                        _buildSummaryRow(
                            'الصافي النهائي:', grandTotal, fontBold,
                            isTotal: true),
                        pw.Divider(color: PdfColors.grey300),
                        _buildSummaryRow('المدفوع:', paid, fontBold,
                            color: PdfColors.green700),
                        pw.Divider(color: PdfColors.grey300),
                        _buildSummaryRow('المتبقي (آجل):', remaining, fontBold,
                            color: PdfColors.red700),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
        bytes: bytes, filename: 'Purchase_Invoice_$invoiceId.pdf');
  }

  static pw.Widget _buildSummaryRow(
      String label, double value, pw.Font fontBold,
      {bool isTotal = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(font: fontBold, fontSize: isTotal ? 14 : 12)),
          pw.Text('$value ج.م',
              style: pw.TextStyle(
                  font: fontBold,
                  fontSize: isTotal ? 14 : 12,
                  color: color ?? PdfColors.black)),
        ],
      ),
    );
  }
}
