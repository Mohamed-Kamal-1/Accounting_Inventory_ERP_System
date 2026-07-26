import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ReportsRemoteDataSource {
  Future<Map<String, dynamic>> fetchDashboardStats();
}

@Singleton(as: ReportsRemoteDataSource)
class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<Map<String, dynamic>> fetchDashboardStats() async {
    final response = await _supabase.rpc('get_dashboard_stats');

    // معالجة الأخطاء والـ Cast لضمان عدم انهيار التطبيق
    if (response == null) return {};
    if (response is List && response.isNotEmpty) {
      return Map<String, dynamic>.from(response.first as Map);
    }
    return Map<String, dynamic>.from(response as Map);
  }
}
