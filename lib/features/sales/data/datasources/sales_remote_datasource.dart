import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/sale_invoice_entity.dart';

abstract class SalesRemoteDataSource {
  Future<bool> createSaleInvoice(SaleInvoiceEntity invoice);
}

@Injectable(as: SalesRemoteDataSource)
class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final SupabaseClient supabaseClient;

  SalesRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<bool> createSaleInvoice(SaleInvoiceEntity invoice) async {
    try {
      // تحويل قائمة الأصناف إلى صيغة يفهمها JSONB في قاعدة البيانات
      final itemsList = invoice.items
          .map((item) => {
                'product_id': item.productId,
                'quantity': item.quantity,
                'unit_price': item.unitPrice,
                'item_discount_percent': item.itemDiscountPercent,
                'total': item.total,
              })
          .toList();

      // استدعاء الدالة المجمعة (RPC) بطلب واحد فقط
      final response =
          await supabaseClient.rpc('create_complete_sale_invoice', params: {
        'p_contact_id': invoice.contactId,
        'p_contact_name': invoice.contactName,
        'p_mode': invoice.mode,
        'p_city': invoice.city,
        'p_line_name': invoice.lineName,
        'p_sub_total': invoice.subTotal,
        'p_discount_percent': invoice.invoiceDiscountPercent,
        'p_grand_total': invoice.grandTotal,
        'p_paid_amount': invoice.paidAmount,
        'p_remaining_amount': invoice.remainingAmount,
        'p_items': itemsList,
      });

      return response['success'] == true;
    } on PostgrestException catch (e) {
      if (e.message.contains('الكمية غير متاحة')) {
        throw ServerException(
            message: 'فشل الحفظ: الرصيد في المخزن لا يكفي لبعض الأصناف.');
      }
      throw ServerException(message: 'خطأ في قاعدة البيانات: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع أثناء حفظ الفاتورة');
    }
  }
}
