// lib/features/inventory/domain/repositories/inventory_repository.dart

import '../../../../core/error/api_result.dart';
import '../entities/category_entity.dart';
import '../entities/inventory_transaction_entity.dart'; // استيراد الملف الصحيح للـ Entity
import '../entities/product_entity.dart';
import '../entities/salesman_custody_entity.dart';

abstract class InventoryRepository {
  // التصنيفات
  Future<Result<List<CategoryEntity>>> getCategories();
  Future<Result<void>> addCategory(String name);
  Future<Result<void>> deleteCategory(String id);

  // الأصناف
  Future<Result<List<ProductEntity>>> getProducts();
  Future<Result<void>> addProduct(ProductEntity product, int initialQuantity);
  Future<Result<void>> updateProduct(ProductEntity product);
  Future<Result<void>> deleteProduct(String id);

  // جلب سجل الحركات الكاملة للعهدة (سحب ومرتجع) لمندوب معين أو للجميع
  Future<Result<List<InventoryTransactionEntity>>> getCustodyTransactions({
    String? salesmanId,
  });

  // جلب الأرصدة الحالية للعهدة لكل مندوب
  Future<Result<List<SalesmanCustodyEntity>>> getSalesmanCurrentCustody(
    String salesmanId,
  );
}
