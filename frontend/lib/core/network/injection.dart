import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/core/network/dio_network.dart';
import 'package:basketvibe/core/services/secure_token_storage.dart';
import 'package:basketvibe/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/google_sign_in_datasource.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/games/data/repositories/game_repository_impl.dart';
import 'package:basketvibe/features/games/domain/repositories/game_repository.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:basketvibe/features/onboarding/domain/usecases/set_onboarding_complete_usecase.dart';
import 'package:basketvibe/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  // Storage
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(prefs),
  );
  getIt.registerLazySingleton<SecureTokenStorage>(() => SecureTokenStorage());

  // Network
  DioNetwork.initDio();
  getIt.registerLazySingleton<Dio>(() => DioNetwork.appAPI);

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<GoogleSignInDatasource>(
    () => GoogleSignInDatasource(),
  );

  // Game
  getIt.registerLazySingleton<GameRepository>(() => GameRepositoryImpl());

  // Cubits / Blocs
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt(), getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<GameCubit>(() => GameCubit(getIt()));
  getIt.registerFactory<CheckOnboardingStatusUseCase>(
    () => CheckOnboardingStatusUseCase(getIt()),
  );
  getIt.registerFactory<SetOnboardingCompleteUseCase>(
    () => SetOnboardingCompleteUseCase(getIt()),
  );
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      checkOnboardingStatusUseCase: getIt(),
      setOnboardingCompleteUseCase: getIt(),
    ),
  );
}
