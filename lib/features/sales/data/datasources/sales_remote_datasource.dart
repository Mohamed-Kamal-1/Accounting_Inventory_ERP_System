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
    // 1. التحقق من توفر الكميات (للتأكد قبل إتمام الفاتورة)
    for (var item in invoice.items) {
      final productRes = await supabaseClient
          .from('products')
          .select('quantity')
          .eq('id', item.productId)
          .maybeSingle();

      if (productRes == null) {
        throw NotFoundException(
            message: 'الصنف (${item.productName}) غير موجود بقاعدة البيانات');
      }

      final currentStock = productRes['quantity'] as int? ?? 0;
      if (currentStock < item.quantity) {
        throw ServerException(
          message:
              'الصنف (${item.productName}) الكمية المتاحة منه حالياً $currentStock فقط',
        );
      }
    }

    // 2. إدراج رأس الفاتورة
    final invoiceResponse = await supabaseClient
        .from('invoices')
        .insert({
          'contact_id': invoice.contactId,
          'type': 'sale',
          'total_amount': invoice.grandTotal,
          'paid_amount': invoice.paidAmount,
          'remaining_amount': invoice.remainingAmount,
          'created_at': invoice.date.toIso8601String(),
        })
        .select()
        .single();

    final invoiceId = invoiceResponse['id'];

    // 3. إدراج الأصناف داخل الفاتورة
    final itemsToInsert = invoice.items
        .map((item) => {
              'invoice_id': invoiceId,
              'product_id': item.productId,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
              'subtotal': item.total,
            })
        .toList();

    await supabaseClient.from('invoice_items').insert(itemsToInsert);

    // 4. استدعاء دوال الـ RPC المخصصة للخصم وتحديث الرصيد بأمان
    for (var item in invoice.items) {
      await supabaseClient.rpc('decrement_product_quantity', params: {
        'x_product_id': item.productId,
        'x_qty': item.quantity,
      });
    }

    if (invoice.remainingAmount != 0) {
      double balanceChange = invoice.mode == 'supplier'
          ? -invoice.remainingAmount
          : invoice.remainingAmount;

      await supabaseClient.rpc('update_contact_balance', params: {
        'x_contact_id': invoice.contactId,
        'x_amount': balanceChange,
      });
    }

    return true;
  }
}
