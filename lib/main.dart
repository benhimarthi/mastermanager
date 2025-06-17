import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mastermanager/core/service/depenedancy.injection.dart';
import 'package:mastermanager/features/authentication/domain/entities/user.dart';
import 'package:mastermanager/firebase_options.dart';

import 'core/session/session.manager.dart';
import 'core/app_theme/app.theme.dart';
import 'features/authentication/presentation/cubit/authentication.cubit.dart';
import 'features/authentication/presentation/pages/login_screen/login.screen.dart';
import 'features/authentication/presentation/pages/registration_screen/registration.screen.dart';
import 'features/authentication/presentation/pages/splash_screen/splash.screen.dart';
import 'features/authentication/presentation/pages/user_management_screen/user.manager.screen.dart';

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

class MyApp extends StatelessWidget {
  final User? startingUser;

  const MyApp({
    super.key,
    required this.startingUser,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
            create: (context) => getIt<AuthenticationCubit>()),
      ],
      child: MaterialApp.router(
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
          ],
        ),
      ),
    );
  }
}
