import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadInventoryEvent extends InventoryEvent {}

class AddCategoryEvent extends InventoryEvent {
  final String name;
  const AddCategoryEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteCategoryEvent extends InventoryEvent {
  final String id;
  const DeleteCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddProductEvent extends InventoryEvent {
  final ProductEntity product;
  final int initialQuantity;

  const AddProductEvent(this.product, this.initialQuantity);

  @override
  List<Object?> get props => [product, initialQuantity];
}

class UpdateProductEvent extends InventoryEvent {
  final ProductEntity product;
  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends InventoryEvent {
  final String id;
  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchProductsEvent extends InventoryEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategoryEvent extends InventoryEvent {
  final String categoryId;
  const FilterByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
