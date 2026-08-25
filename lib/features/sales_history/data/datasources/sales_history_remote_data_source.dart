import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/invoice_details_model.dart';
import '../models/invoice_header_model.dart';

@lazySingleton
class SalesHistoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  SalesHistoryRemoteDataSource({required this.supabaseClient});

  Future<List<InvoiceHeaderModel>> getSalesHistory({
    required String searchTerm,
    DateTime? startDate,
    DateTime? endDate,
    required int limit,
    required int offset,
  }) async {
    String? startStr = startDate != null
        ? "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}"
        : null;
    String? endStr = endDate != null
        ? "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}"
        : null;

    final params = {
      'p_search_term': searchTerm.trim().isEmpty ? null : searchTerm.trim(),
      'p_start_date': startStr,
      'p_end_date': endStr,
      'p_limit': limit,
      'p_offset': offset,
    };

    final response = await supabaseClient.rpc(
      'get_sales_history_v3',
      params: params,
    );

    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) =>
            InvoiceHeaderModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<List<InvoiceDetailsModel>> getInvoiceDetails(String invoiceId) async {
    final response = await supabaseClient.rpc(
      'get_invoice_details',
      params: {
        'p_invoice_id': invoiceId,
      },
    );

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => InvoiceDetailsModel.fromJson(json)).toList();
  }
}
