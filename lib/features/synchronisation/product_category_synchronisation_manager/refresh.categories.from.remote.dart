import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../../core/util/typedef.dart';
import '../../product_category/data/data_sources/product.category.local.data.source.dart';
import '../../product_category/data/data_sources/product.category.remote.data.source.dart';

class RefreshCategoriesFromRemote {
  final ProductCategoryRemoteDataSource remote;
  final ProductCategoryLocalDataSource local;

  RefreshCategoriesFromRemote(this.remote, this.local);

  ResultFuture<void> call() async {
    try {
      final remoteCategories = await remote.getAllCategories();

      await local.clearAll(); // new method to empty local + pending queues
      for (final cat in remoteCategories) {
        await local.applyCreate(cat); // insert into local cache only
      }
      return const Right(null);
    } catch (_) {
      return const Left(ServerFailure(
          message: 'Failed to refresh from remote', statusCode: 500));
    }
  }
}
