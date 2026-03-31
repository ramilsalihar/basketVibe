import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/app/app_bloc_observer.dart';
import 'package:basketvibe/core/app/di/injection.dart';
import 'package:basketvibe/core/app/theme_cubit.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/core/router/app_router.dart';
import 'package:basketvibe/core/styles/app_theme.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Bloc.observer = AppBlocObserver();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) =>
              ThemeCubit(getIt<LocalStorageService>())..loadThemeMode(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'BasketVibe',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
