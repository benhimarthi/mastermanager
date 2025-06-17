import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mastermanager/features/authentication/domain/usecases/get.users.dart';

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

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('authenticationBox'); // Open the authentication box

  // Register Firebase Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
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
}
