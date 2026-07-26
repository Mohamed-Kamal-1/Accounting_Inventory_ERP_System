import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final List<CategoryEntity> categories;
  final String selectedCategoryId;
  final String searchQuery;

  const InventoryLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.categories,
    this.selectedCategoryId = 'all',
    this.searchQuery = '',
  });

  InventoryLoaded copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return InventoryLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        categories,
        selectedCategoryId,
        searchQuery
      ];
}

class InventoryActionSuccess extends InventoryState {
  final String message;
  const InventoryActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}
