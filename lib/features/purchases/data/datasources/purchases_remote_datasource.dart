import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PurchasesRemoteDataSource {
  Future<void> createPurchaseInvoice(
      Map<String, dynamic> invoice, List<Map<String, dynamic>> items);
}

@Singleton(as: PurchasesRemoteDataSource)
class PurchasesRemoteDataSourceImpl implements PurchasesRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<void> createPurchaseInvoice(
      Map<String, dynamic> invoice, List<Map<String, dynamic>> items) async {
    invoice['invoice_type'] = 'purchase';

    final invoiceResult =
        await _supabase.from('invoices').insert(invoice).select('id').single();
    final String invoiceId = invoiceResult['id'];

    if (items.isNotEmpty) {
      final List<Map<String, dynamic>> itemsToInsert = items.map((item) {
        return {
          ...item,
          'invoice_id': invoiceId,
        };
      }).toList();
      await _supabase.from('invoice_items').insert(itemsToInsert);
    }

    final paidAmount = invoice['paid_amount'] ?? 0.0;
    if (paidAmount > 0) {
      await _supabase.from('treasury_transactions').insert({
        'transaction_type': 'purchase_payment',
        'amount': paidAmount,
        'description': 'دفعة نقدية لفاتورة مشتريات',
        'reference_id': invoiceId,
      });
    }
  }
}
