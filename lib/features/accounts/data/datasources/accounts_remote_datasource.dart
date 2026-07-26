import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AccountsRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchAllAccounts();
  Future<void> insertAccount(Map<String, dynamic> accountData);
  Future<void> removeAccount(String id);
}

@Singleton(as: AccountsRemoteDataSource)
class AccountsRemoteDataSourceImpl implements AccountsRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> fetchAllAccounts() async {
    final response = await _supabase.from('accounts').select();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> insertAccount(Map<String, dynamic> accountData) async {
    await _supabase.from('accounts').upsert(accountData);
  }

  @override
  Future<void> removeAccount(String id) async {
    await _supabase.from('accounts').delete().eq('id', id);
  }
}
