import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mastermanager/features/authentication/data/data_source/sync.manager.dart';
import 'package:mastermanager/features/authentication/domain/usecases/get.users.dart';
import 'package:mastermanager/features/product/data/data_sources/product.local.data.source.dart';
import 'package:mastermanager/features/product/data/data_sources/product.remote.data.source.dart';
import 'package:mastermanager/features/product/data/repositories/product.repository.impl.dart';
import 'package:mastermanager/features/product/domain/repositories/product.repository.dart';
import 'package:mastermanager/features/product/domain/usecases/create.product.dart';
import 'package:mastermanager/features/product/domain/usecases/delete.product.dart';
import 'package:mastermanager/features/product/domain/usecases/get.all.product.dart';
import 'package:mastermanager/features/product/domain/usecases/update.product.dart';
import 'package:mastermanager/features/product_category/data/data_sources/product.category.remote.data.source.dart';
import 'package:mastermanager/features/product_category/presentation/cubit/local.category.manager.cubit.dart';
import 'package:mastermanager/features/product_pricing/data/data_source/product.pricing.local.data.source.dart';
import 'package:mastermanager/features/product_pricing/data/data_source/product.pricing.remote.data.source.dart';
import 'package:mastermanager/features/product_pricing/data/repositories/product.pricing.repository.impl.dart';
import 'package:mastermanager/features/product_pricing/domain/repositories/product.pricing.repository.dart';
import 'package:mastermanager/features/product_pricing/domain/usecases/create.product.pricing.dart';
import 'package:mastermanager/features/product_pricing/domain/usecases/delete.product.pricing.dart';
import 'package:mastermanager/features/product_pricing/domain/usecases/get.all.product.pricing.dart';
import 'package:mastermanager/features/product_pricing/domain/usecases/update.product.pricing.dart';
import 'package:mastermanager/features/product_pricing/presentation/cubit/product.pricing.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_category_sync_manager_cubit/product.category.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_pricing_sync_manager_cubit/product.pricing.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_sync_manager_cubit/product.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/product_category_synchronisation_manager/product.category.sync.manager.dart';
import 'package:mastermanager/features/synchronisation/product_category_synchronisation_manager/product.pricing.sync.manager.dart';
import 'package:mastermanager/features/synchronisation/product_category_synchronisation_manager/product.sync.manager.dart';
import 'package:mastermanager/features/synchronisation/product_category_synchronisation_manager/refresh.categories.from.remote.dart';

import '../../features/authentication/data/data_source/authentication.local.data.source.dart';
import '../../features/authentication/data/data_source/authentictaion.remote.data.source.dart';
import '../../features/authentication/data/repositories/authentication.repository.impl.dart';
import '../../features/authentication/domain/repositories/authentication.repository.dart';
import '../../features/authentication/domain/usecases/create.user.dart';
import '../../features/authentication/domain/usecases/delete.user.dart';
import '../../features/authentication/domain/usecases/get.current.user.dart';
import '../../features/authentication/domain/usecases/login.user.dart';
import '../../features/authentication/domain/usecases/login.with.google.dart';
import '../../features/authentication/domain/usecases/logout.user.dart';
import '../../features/authentication/domain/usecases/update.user.dart';
import '../../features/authentication/presentation/cubit/authentication.cubit.dart';
import '../../features/product/presentation/cubit/product.cubit.dart';
import '../../features/product_category/data/data_sources/product.category.local.data.source.dart';
import '../../features/product_category/data/repositories/product.category.repository.impl.dart';
import '../../features/product_category/domain/repositories/product.category.repository.dart';
import '../../features/product_category/domain/usecases/create.product.category.dart';
import '../../features/product_category/domain/usecases/delete.product.category.dart';
import '../../features/product_category/domain/usecases/get.all.product.categories.dart';
import '../../features/product_category/domain/usecases/get.product.category.by.id.dart';
import '../../features/product_category/domain/usecases/update.product.category.dart';
import '../../features/synchronisation/cubit/authentication_synch_manager_cubit/sync.trigger.cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('authenticationBox'); // Open the authentication box

  // Register Firebase Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<Box>(() => Hive.box('authenticationBox'));

  // Register Data Sources
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSrcImpl(
        getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSrcImpl(getIt<Box>()),
  );

  // Register Repositories
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImplementation(
        getIt<AuthenticationRemoteDataSource>(),
        getIt<AuthenticationLocalDataSource>()),
  );

  //Rgistration of the synchronisator
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(
      getIt<AuthenticationRemoteDataSource>(),
      getIt<AuthenticationLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<SyncTriggerCubit>(
      () => SyncTriggerCubit(getIt<SyncManager>()));

  // Register Use Cases
  getIt.registerLazySingleton<CreateUser>(
      () => CreateUser(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<LoginUser>(
      () => LoginUser(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<LoginWithGoogle>(
      () => LoginWithGoogle(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<GetUsers>(
      () => GetUsers(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<GetCurrentUser>(
      () => GetCurrentUser(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<UpdateUser>(
      () => UpdateUser(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<DeleteUser>(
      () => DeleteUser(getIt<AuthenticationRepository>()));
  getIt.registerLazySingleton<LogoutUser>(
      () => LogoutUser(getIt<AuthenticationRepository>()));

  // Register Cubit for Authentication
  getIt.registerFactory(() => AuthenticationCubit(
        createUser: getIt<CreateUser>(),
        getUsers: getIt<GetUsers>(),
        loginUser: getIt<LoginUser>(),
        loginWithGoogle: getIt<LoginWithGoogle>(),
        updateUser: getIt<UpdateUser>(),
        deleteUser: getIt<DeleteUser>(),
        logoutUser: getIt<LogoutUser>(),
        getCurrentUser: getIt<GetCurrentUser>(),
      ));

  // Open Hive boxes
  final mainBox = await Hive.openBox('product_categories');
  final createdBox = await Hive.openBox('product_categories_created');
  final updatedBox = await Hive.openBox('product_categories_updated');
  final deletedBox = await Hive.openBox('product_categories_deleted');
  // Local Data Source
  getIt
    ..registerFactory(() => LocalCategoryManagerCubit(
          getAll: getIt(),
          create: getIt(),
          update: getIt(),
          delete: getIt(),
          connectivity: getIt(),
          syncCubit: getIt(),
        ))
    ..registerLazySingleton(() => CreateProductCategory(getIt()))
    ..registerLazySingleton(() => GetAllProductCategories(getIt()))
    ..registerLazySingleton(() => GetProductCategoryById(getIt()))
    ..registerLazySingleton(() => UpdateProductCategory(getIt()))
    ..registerLazySingleton(() => DeleteProductCategory(getIt()))
    ..registerLazySingleton<ProductCategoryLocalDataSource>(
      () => ProductCategoryLocalDataSourceImpl(
        mainBox: mainBox,
        createdBox: createdBox,
        updatedBox: updatedBox,
        deletedBox: deletedBox,
      ),
    )
    ..registerLazySingleton<ProductCategoryRemoteDataSource>(
      () => ProductCategoryRemoteDataSourceImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ProductCategoryRepository>(
      () => ProductCategoryRepositoryImpl(getIt()),
    );

  getIt
    ..registerLazySingleton(() => ProductCategorySyncManager(
          getIt<ProductCategoryLocalDataSource>(),
          getIt<ProductCategoryRemoteDataSource>(),
        ))
    ..registerFactory(() => ProductCategorySyncTriggerCubit(getIt()));

  getIt.registerLazySingleton(
    () => RefreshCategoriesFromRemote(
      getIt(),
      getIt(),
    ),
  );

  final ppm = await Hive.openBox('product_pricing_main');
  final ppc = await Hive.openBox('product_pricing_created');
  final ppu = await Hive.openBox('product_pricing_updated');
  final ppd = await Hive.openBox<String>('product_pricing_deleted');

  getIt
    ..registerFactory(
      () => ProductPricingCubit(
        getAll: getIt(),
        create: getIt(),
        update: getIt(),
        delete: getIt(),
        syncCubit: getIt(),
        connectivity: getIt(),
      ),
    )
    ..registerLazySingleton(() => GetAllProductPricing(getIt()))
    ..registerLazySingleton(() => CreateProductPricing(getIt()))
    ..registerLazySingleton(() => UpdateProductPricing(getIt()))
    ..registerLazySingleton(() => DeleteProductPricing(getIt()))
    ..registerLazySingleton(() => ProductPricingSyncTriggerCubit(getIt()))
    ..registerLazySingleton<ProductPricingRepository>(
      () => ProductPricingRepositoryImpl(
        local: getIt(),
      ),
    )
    ..registerLazySingleton<ProductPricingLocalDataSource>(
      () => ProductPricingLocalDataSourceImpl(
        mainBox: ppm,
        createdBox: ppc,
        updatedBox: ppu,
        deletedBox: ppd,
      ),
    )
    ..registerLazySingleton<ProductPricingRemoteDataSource>(
      () => ProductPricingRemoteDataSourceImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ProductPricingSyncManager>(
      () => ProductPricingSyncManagerImpl(
        getIt(),
        getIt(),
      ),
    );

  final productBox = await Hive.openBox('products');
  final createdProductBox = await Hive.openBox('products_created');
  final updatedProductBox = await Hive.openBox('products_updated');
  final deletedProductBox = await Hive.openBox('products_deleted');

  getIt
    ..registerFactory(
      () => ProductCubit(
        create: getIt(),
        getAll: getIt(),
        update: getIt(),
        delete: getIt(),
        connectivity: getIt(),
        syncCubit: getIt(),
      ),
    )
    ..registerLazySingleton(() => CreateProduct(getIt()))
    ..registerLazySingleton(() => GetAllProducts(getIt()))
    ..registerLazySingleton(() => UpdateProduct(getIt()))
    ..registerLazySingleton(() => DeleteProduct(getIt()))
    ..registerLazySingleton(() => ProductSyncTriggerCubit(getIt()))
    ..registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(local: getIt()))
    ..registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(
        mainBox: productBox,
        createdBox: createdProductBox,
        updatedBox: updatedProductBox,
        deletedBox: deletedProductBox,
      ),
    )
    ..registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(getIt()))
    ..registerLazySingleton<ProductSyncManager>(
        () => ProductSyncManagerImpl(getIt(), getIt()));
}
