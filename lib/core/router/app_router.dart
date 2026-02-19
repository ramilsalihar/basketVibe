import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../constants/route_constants.dart';
import '../app/di/injection.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<OnboardingBloc>(),
          child: const SplashPage(),
        ),
      ),

      // Onboarding
      GoRoute(
        path: RouteConstants.onboarding,
        name: 'onboarding',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<OnboardingBloc>(),
          child: const OnboardingPage(),
        ),
      ),

      // Login
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Home
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // TODO: Add more routes as features are implemented
      // Register
      // Games routes
      // Courts routes
      // Profile routes
    ],
  );
}
