import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/network/execute_supabase.dart'; // استدعاء الجسر هنا
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/inventory_transaction_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/salesman_custody_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';
import '../models/product_model.dart';

@Injectable(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    return executeSupabase(() async {
      return await remoteDataSource.getCategories();
    });
  }

  @override
  Future<Result<void>> addCategory(String name) async {
    return executeSupabase(() async {
      await remoteDataSource.addCategory(name);
    });
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    return executeSupabase(() async {
      await remoteDataSource.deleteCategory(id);
    });
  }

  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    return executeSupabase(() async {
      return await remoteDataSource.getProducts();
    });
  }

  @override
  Future<Result<void>> addProduct(
      ProductEntity product, int initialQuantity) async {
    return executeSupabase(() async {
      final model = ProductModel(
        id: product.id,
        categoryId: product.categoryId,
        name: product.name,
        purchasePrice: product.purchasePrice,
        salePrice: product.salePrice,
        surveyPrice: product.surveyPrice,
        minQty: product.minQty,
        showToSurvey: product.showToSurvey,
      );
      await remoteDataSource.addProduct(model, initialQuantity);
    });
  }

  @override
  Future<Result<void>> updateProduct(ProductEntity product) async {
    return executeSupabase(() async {
      final model = ProductModel(
        id: product.id,
        categoryId: product.categoryId,
        name: product.name,
        purchasePrice: product.purchasePrice,
        salePrice: product.salePrice,
        surveyPrice: product.surveyPrice,
        minQty: product.minQty,
        showToSurvey: product.showToSurvey,
      );
      await remoteDataSource.updateProduct(model);
    });
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    return executeSupabase(() async {
      await remoteDataSource.deleteProduct(id);
    });
  }

  @override
  Future<Result<List<InventoryTransactionEntity>>> getCustodyTransactions(
      {String? salesmanId}) async {
    return executeSupabase(() async {
      final data =
          await remoteDataSource.getCustodyTransactions(salesmanId: salesmanId);

      return data
          .map((json) => InventoryTransactionEntity(
                id: json['id'] as String,
                productId: json['product_id'] as String,
                productName: json['products']['name'] as String,
                type: json['type'] as String,
                quantity: json['quantity'] as int,
                createdAt: DateTime.parse(json['created_at'] as String),
                notes: json['notes'] as String?,
              ))
          .toList();
    });
  }

  @override
  Future<Result<List<SalesmanCustodyEntity>>> getSalesmanCurrentCustody(
      String salesmanId) async {
    return executeSupabase(() async {
      final data = await remoteDataSource.getSalesmanCurrentCustody(salesmanId);

      return data
          .map((json) => SalesmanCustodyEntity(
                salesmanId: json['salesman_id'] as String,
                productId: json['product_id'] as String,
                productName: json['products']['name'] as String,
                currentQty: (json['current_qty'] as num).toInt(),
              ))
          .toList();
    });
  }
}
