import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../styles/app_theme.dart';
import '../router/app_router.dart';
import 'app_bloc_observer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up BLoC observer
    Bloc.observer = AppBlocObserver();

    return MaterialApp.router(
      title: 'BasketVibe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
