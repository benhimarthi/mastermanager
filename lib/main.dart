import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mastermanager/core/service/depenedancy.injection.dart';
import 'package:mastermanager/features/Inventory/presentation/cubit/inventory.cubit.dart';
import 'package:mastermanager/features/authentication/domain/entities/user.dart';
import 'package:mastermanager/features/product/presentation/cubit/product.cubit.dart';
import 'package:mastermanager/features/product_category/presentation/cubit/local.category.manager.cubit.dart';
import 'package:mastermanager/features/product_category/presentation/pages/product.category.page.dart';
import 'package:mastermanager/features/product_pricing/presentation/cubit/product.pricing.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/inventory_meta_data_cubit/inventory.meta.data.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/inventory_meta_data_sync_trigger_cubit/inventory.meta.data.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/inventory_sync_trigger_cubit/inventory.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_category_sync_manager_cubit/product.category.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_pricing_sync_manager_cubit/product.pricing.sync.trigger.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_sync_manager_cubit/product.sync.trigger.cubit.dart';
import 'package:mastermanager/firebase_options.dart';
import 'core/session/session.manager.dart';
import 'core/app_theme/app.theme.dart';
import 'features/authentication/presentation/cubit/authentication.cubit.dart';
import 'features/authentication/presentation/pages/login_screen/login.screen.dart';
import 'features/authentication/presentation/pages/registration_screen/registration.screen.dart';
import 'features/authentication/presentation/pages/splash_screen/splash.screen.dart';
import 'features/authentication/presentation/pages/user_management_screen/user.manager.screen.dart';
import 'features/synchronisation/cubit/authentication_synch_manager_cubit/sync.trigger.cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDependencyInjection();
  final savedUser = SessionManager.getUserSession();

  runApp(
    MyApp(
      startingUser: savedUser,
    ),
  );
}

class MyApp extends StatefulWidget {
  final User? startingUser;

  const MyApp({
    super.key,
    required this.startingUser,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    final syncTriggerCubit = GetIt.instance<SyncTriggerCubit>();
    syncTriggerCubit.runOnAppStart();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
              create: (context) => getIt<AuthenticationCubit>()),
          BlocProvider<SyncTriggerCubit>(
              create: (context) => getIt<SyncTriggerCubit>()),
          BlocProvider<LocalCategoryManagerCubit>(
              create: (context) => getIt<LocalCategoryManagerCubit>()),
          BlocProvider<ProductCategorySyncTriggerCubit>(
              create: (context) => getIt<ProductCategorySyncTriggerCubit>()),
          BlocProvider<ProductPricingCubit>(
              create: (context) => getIt<ProductPricingCubit>()),
          BlocProvider<ProductPricingSyncTriggerCubit>(
              create: (context) => getIt<ProductPricingSyncTriggerCubit>()),
          BlocProvider<ProductCubit>(
              create: (context) => getIt<ProductCubit>()),
          BlocProvider<ProductSyncTriggerCubit>(
              create: (context) => getIt<ProductSyncTriggerCubit>()),
          BlocProvider<InventoryCubit>(
              create: (context) => getIt<InventoryCubit>()),
          BlocProvider<InventorySyncTriggerCubit>(
            create: (context) => getIt<InventorySyncTriggerCubit>(),
          ),
          BlocProvider<InventoryMetadataCubit>(
            create: (context) => getIt<InventoryMetadataCubit>(),
          ),
          BlocProvider<InventoryMetadataSyncTriggerCubit>(
            create: (context) => getIt<InventoryMetadataSyncTriggerCubit>(),
          ),
        ],
        child: Builder(builder: ((context) {
          return MaterialApp.router(
            title: 'your Manager',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: GoRouter(
              initialLocation: "/splash", // Corrected
              routes: [
                GoRoute(
                    path: '/splash',
                    builder: (context, state) => const SplashScreen()),
                GoRoute(
                    path: '/login',
                    builder: (context, state) => const LoginScreen()),
                GoRoute(
                    path: '/register',
                    builder: (context, state) => const RegistrationScreen()),
                GoRoute(
                    path: '/users',
                    builder: (context, state) => const UserManagementScreen()),
                GoRoute(
                    path: '/categories',
                    builder: (context, state) => const ProductCategoryPage()),
              ],
            ),
          );
        })));
  }
}
