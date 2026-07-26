import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/category_usecases.dart';
import '../../domain/usecases/product_usecases.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  InventoryBloc(
    this._getCategoriesUseCase,
    this._addCategoryUseCase,
    this._deleteCategoryUseCase,
    this._getProductsUseCase,
    this._addProductUseCase,
    this._updateProductUseCase,
    this._deleteProductUseCase,
  ) : super(InventoryInitial()) {
    on<LoadInventoryEvent>(_onLoadInventory);
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterByCategoryEvent>(_onFilterByCategory);
  }

  Future<void> _onLoadInventory(
      LoadInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final catResult = await _getCategoriesUseCase();
    final prodResult = await _getProductsUseCase();

    catResult.fold(
      onFailure: (failure) => emit(InventoryError(failure.message)),
      onSuccess: (categories) {
        prodResult.fold(
          onFailure: (failure) => emit(InventoryError(failure.message)),
          onSuccess: (products) {
            emit(InventoryLoaded(
              allProducts: products,
              filteredProducts: products,
              categories: categories,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddCategory(
      AddCategoryEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await _addCategoryUseCase(event.name);
    result.fold(
      onFailure: (failure) => emit(InventoryError(failure.message)),
      onSuccess: (_) {
        emit(const InventoryActionSuccess('تمت إضافة القسم بنجاح'));
        add(LoadInventoryEvent());
      },
    );
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await _deleteCategoryUseCase(event.id);
    result.fold(
      onFailure: (failure) => emit(InventoryError(failure.message)),
      onSuccess: (_) {
        emit(const InventoryActionSuccess('تم حذف القسم بنجاح'));
        add(LoadInventoryEvent());
      },
    );
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result =
        await _addProductUseCase(event.product, event.initialQuantity);
    result.fold(
      onFailure: (failure) => emit(InventoryError(failure.message)),
      onSuccess: (_) {
        emit(const InventoryActionSuccess(
            'تم حفظ الصنف الجديد ورصيده الافتتاحي'));
        add(LoadInventoryEvent());
      },
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await _updateProductUseCase(event.product);
    result.fold(
      onFailure: (failure) => emit(InventoryError(failure.message)),
      onSuccess: (_) {
        emit(const InventoryActionSuccess('تم تحديث بيانات الصنف بنجاح'));
        add(LoadInventoryEvent());
      },
    );
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await _deleteProductUseCase(event.id);
    result.fold(
      onFailure: (failure) => emit(InventoryError(failure.message)),
      onSuccess: (_) {
        emit(const InventoryActionSuccess('تم حذف الصنف نهائياً'));
        add(LoadInventoryEvent());
      },
    );
  }

  void _onSearchProducts(
      SearchProductsEvent event, Emitter<InventoryState> emit) {
    if (state is InventoryLoaded) {
      final currentState = state as InventoryLoaded;
      final updatedState = currentState.copyWith(searchQuery: event.query);
      emit(updatedState.copyWith(filteredProducts: _filterList(updatedState)));
    }
  }

  void _onFilterByCategory(
      FilterByCategoryEvent event, Emitter<InventoryState> emit) {
    if (state is InventoryLoaded) {
      final currentState = state as InventoryLoaded;
      final updatedState =
          currentState.copyWith(selectedCategoryId: event.categoryId);
      emit(updatedState.copyWith(filteredProducts: _filterList(updatedState)));
    }
  }

  List<ProductEntity> _filterList(InventoryLoaded state) {
    return state.allProducts.where((product) {
      final matchesCategory = state.selectedCategoryId == 'all' ||
          product.categoryId == state.selectedCategoryId;
      final matchesSearch = product.name
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase()) ||
          product.id.toLowerCase().contains(state.searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
