import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../entities/category_entity.dart';
import '../repositories/inventory_repository.dart';

@injectable
class GetCategoriesUseCase {
  final InventoryRepository repository;
  GetCategoriesUseCase(this.repository);
  Future<Result<List<CategoryEntity>>> call() => repository.getCategories();
}

@injectable
class AddCategoryUseCase {
  final InventoryRepository repository;
  AddCategoryUseCase(this.repository);
  Future<Result<void>> call(String name) => repository.addCategory(name);
}

@injectable
class DeleteCategoryUseCase {
  final InventoryRepository repository;
  DeleteCategoryUseCase(this.repository);
  Future<Result<void>> call(String id) => repository.deleteCategory(id);
}
