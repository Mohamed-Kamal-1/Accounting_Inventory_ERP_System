import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

@injectable
class InventoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  InventoryRemoteDataSource(this.supabaseClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'فشل جلب التصنيفات: ${e.toString()}');
    }
  }

  @override
  Future<void> addCategory(String name) async {
    try {
      await supabaseClient.from('categories').insert({'name': name});
    } catch (e) {
      throw ServerException(
          message: 'فشل إضافة التصنيف. قد يكون الاسم مكرراً.');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await supabaseClient.from('categories').delete().eq('id', id);
    } catch (e) {
      throw ServerException(message: 'لا يمكن حذف تصنيف يحتوي على أصناف.');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // هنا نجلب بيانات الصنف وندمجها مع الـ View لمعرفة الرصيد الحالي
      final response = await supabaseClient
          .from('products')
          .select('*, product_stock(current_quantity)')
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'فشل جلب الأصناف: ${e.toString()}');
    }
  }

  @override
  Future<void> addProduct(ProductModel product, int initialQuantity) async {
    try {
      // 1. إدخال الصنف الجديد وجلب الـ ID الخاص به
      final productResponse = await supabaseClient
          .from('products')
          .insert(product.toJson())
          .select('id')
          .single();

      final productId = productResponse['id'];

      // 2. إذا كانت الكمية الافتتاحية أكبر من صفر، ننشئ حركة مخزنية
      if (initialQuantity > 0) {
        await supabaseClient.from('inventory_transactions').insert({
          'product_id': productId,
          'type': 'opening_balance',
          'quantity': initialQuantity,
          'notes': 'رصيد افتتاحي للنظام',
          'user_id': supabaseClient.auth.currentUser?.id,
        });
      }
    } catch (e) {
      throw ServerException(message: 'فشل حفظ الصنف: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await supabaseClient
          .from('products')
          .update(product.toJson())
          .eq('id', product.id);
    } catch (e) {
      throw ServerException(message: 'فشل تعديل الصنف');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await supabaseClient.from('products').delete().eq('id', id);
    } catch (e) {
      throw ServerException(message: 'فشل الحذف. الصنف مرتبط بحركات سابقة.');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCustodyTransactions(
      {String? salesmanId}) async {
    try {
      var query = supabaseClient
          .from('inventory_transactions')
          .select('*, products(name)');
      if (salesmanId != null) {
        query = query.eq('contact_id', salesmanId);
      }
      // نجلب فقط حركات العهدة (تحويل للمندوب، مبيعاته، مرتجعاته)
      final response = await query
          .inFilter('type', ['transfer_to_rep', 'sale', 'return_in']).order(
              'created_at',
              ascending: false);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw ServerException(message: 'فشل جلب حركات العهدة: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSalesmanCurrentCustody(
      String salesmanId) async {
    try {
      final response = await supabaseClient
          .from('salesman_current_custody')
          .select('*, products(name)')
          .eq('salesman_id', salesmanId);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw ServerException(message: 'فشل جلب عهدة المندوب الحالية');
    }
  }
}
