import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/purchases_history_model.dart';

abstract class PurchasesHistoryRemoteDataSource {
  Future<List<PurchasesHistoryModel>> getPurchasesHistory();
}

@Singleton(as: PurchasesHistoryRemoteDataSource)
class PurchasesHistoryRemoteDataSourceImpl
    implements PurchasesHistoryRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<PurchasesHistoryModel>> getPurchasesHistory() async {
    // 1. جلب الفواتير الأساسية مع اسم المورد
    final invoicesRes = await _supabase
        .from('invoices')
        .select('''
          id, created_at, sub_total, discount, grand_total, 
          paid_amount, remaining_amount, status, contacts (name)
        ''')
        .eq('invoice_type', 'purchase')
        .order('created_at', ascending: false);

    List<PurchasesHistoryModel> historyList = [];

    for (var inv in invoicesRes) {
      // 2. جلب تفاصيل منتجات كل فاتورة على حدة لضمان دقة البيانات
      final itemsRes = await _supabase
          .from('invoice_items')
          .select('quantity, unit_price, total_price, products(name)')
          .eq('invoice_id', inv['id']);

      final itemsList = List<Map<String, dynamic>>.from(itemsRes);

      historyList.add(PurchasesHistoryModel.fromJson(inv, itemsList));
    }

    return historyList;
  }
}
