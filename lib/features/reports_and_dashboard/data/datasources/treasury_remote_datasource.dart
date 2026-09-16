import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/treasury_transaction_model.dart';

abstract class TreasuryRemoteDataSource {
  Future<List<TreasuryTransactionModel>> getTransactions(
      String? startDate, String? endDate);
  Future<void> insertManualDeposit(double amount, String description);
}

@Singleton(as: TreasuryRemoteDataSource)
class TreasuryRemoteDataSourceImpl implements TreasuryRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<TreasuryTransactionModel>> getTransactions(
      String? startDate, String? endDate) async {
    dynamic query = _supabase.from('treasury_transactions').select();

    // 2. تطبيق فلاتر التاريخ
    if (startDate != null) {
      query = query.gte('created_at', '${startDate}T00:00:00.000Z');
    }
    if (endDate != null) {
      query = query.lte('created_at', '${endDate}T23:59:59.999Z');
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => TreasuryTransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> insertManualDeposit(double amount, String description) async {
    await _supabase.from('treasury_transactions').insert({
      'transaction_type': 'manual_deposit',
      'amount': amount,
      'description': description,
    });
  }
}
