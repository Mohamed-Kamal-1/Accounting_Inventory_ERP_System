import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../entities/product_entity.dart';
import '../repositories/inventory_repository.dart';

@injectable
class GetProductsUseCase {
  final InventoryRepository repository;
  GetProductsUseCase(this.repository);
  Future<Result<List<ProductEntity>>> call() => repository.getProducts();
}

@injectable
class AddProductUseCase {
  final InventoryRepository repository;
  AddProductUseCase(this.repository);
  Future<Result<void>> call(ProductEntity product, int initialQuantity) =>
      repository.addProduct(product, initialQuantity);
}

@injectable
class UpdateProductUseCase {
  final InventoryRepository repository;
  UpdateProductUseCase(this.repository);
  Future<Result<void>> call(ProductEntity product) =>
      repository.updateProduct(product);
}

@injectable
class DeleteProductUseCase {
  final InventoryRepository repository;
  DeleteProductUseCase(this.repository);
  Future<Result<void>> call(String id) => repository.deleteProduct(id);
}
