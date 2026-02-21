
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/app/di/injection.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/features/auth/presentation/pages/login_page.dart';
import 'package:basketvibe/features/courts/presentation/pages/court_finder_page.dart';
import 'package:basketvibe/features/games/presentation/pages/create_game_page.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/home/presentation/pages/home_page.dart';
import 'package:basketvibe/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:basketvibe/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:basketvibe/features/onboarding/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    routes: [
      // Splash Screen → navigates to Home after delay
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
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

      // Courts (Court Finder / Map)
      GoRoute(
        path: RouteConstants.courts,
        name: 'courts',
        builder: (context, state) => const CourtFinderPage(),
      ),

      // Create Game
      GoRoute(
        path: RouteConstants.createGame,
        name: 'createGame',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<GameCubit>(),
          child: const CreateGamePage(),
        ),
      ),
    ],
  );
}
