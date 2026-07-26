import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class InvoicesRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> executeInvoiceRpc(Map<String, dynamic> params) async {
    await _supabase.rpc('process_invoice', params: params);
  }
}
