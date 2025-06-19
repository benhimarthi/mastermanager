import 'package:bloc/bloc.dart';

import '../../domain/entities/product.category.dart';
import '../../domain/usecases/create.product.category.dart';
import '../../domain/usecases/delete.product.category.dart';
import '../../domain/usecases/get.all.product.categories.dart';
import '../../domain/usecases/update.product.category.dart';
import 'local.category.manager.state.dart';

class LocalCategoryManagerCubit extends Cubit<LocalCategoryManagerState> {
  final GetAllProductCategories _getAll;
  final CreateProductCategory _create;
  final UpdateProductCategory _update;
  final DeleteProductCategory _delete;

  LocalCategoryManagerCubit({
    required GetAllProductCategories getAll,
    required CreateProductCategory create,
    required UpdateProductCategory update,
    required DeleteProductCategory delete,
  })  : _getAll = getAll,
        _create = create,
        _update = update,
        _delete = delete,
        super(LocalCategoryManagerInitial());

  Future<void> loadCategories() async {
    emit(LocalCategoryManagerLoading());
    final result = await _getAll();
    result.fold(
      (failure) => emit(LocalCategoryManagerError(failure.message)),
      (categories) => emit(LocalCategoryManagerLoaded(categories)),
    );
  }

  Future<void> addCategory(ProductCategory category) async {
    final result = await _create(category);
    result.fold(
      (failure) => emit(LocalCategoryManagerError(failure.message)),
      (_) => loadCategories(),
    );
  }

  Future<void> updateCategory(ProductCategory category) async {
    final result = await _update(category);
    result.fold(
      (failure) => emit(LocalCategoryManagerError(failure.message)),
      (_) => loadCategories(),
    );
  }

  Future<void> deleteCategory(String id) async {
    final result = await _delete(id);
    result.fold(
      (failure) => emit(LocalCategoryManagerError(failure.message)),
      (_) => loadCategories(),
    );
  }
}
