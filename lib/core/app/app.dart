import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/app/app_bloc_observer.dart';
import 'package:basketvibe/core/router/app_router.dart';
import 'package:basketvibe/core/styles/app_theme.dart';

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
