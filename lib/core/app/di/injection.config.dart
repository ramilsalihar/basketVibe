// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../features/auth/presentation/cubit/auth_cubit.dart' as _i20;
import '../../../features/onboarding/domain/di/onboarding_module.dart' as _i96;
import '../../../features/onboarding/domain/usecases/check_onboarding_status_usecase.dart'
    as _i1057;
import '../../../features/onboarding/domain/usecases/set_onboarding_complete_usecase.dart'
    as _i766;
import '../../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i160;
import '../../local_storage/local_storage_service.dart' as _i189;
import 'modules/shared_preferences_module.dart' as _i813;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final onboardingModule = _$OnboardingModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i189.LocalStorageService>(
      () => _i189.LocalStorageServiceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i20.AuthCubit>(
      () => _i20.AuthCubit(gh<_i189.LocalStorageService>()),
    );
    gh.factory<_i1057.CheckOnboardingStatusUseCase>(
      () => onboardingModule.checkOnboardingStatusUseCase(
        gh<_i189.LocalStorageService>(),
      ),
    );
    gh.factory<_i766.SetOnboardingCompleteUseCase>(
      () => onboardingModule.setOnboardingCompleteUseCase(
        gh<_i189.LocalStorageService>(),
      ),
    );
    gh.factory<_i160.OnboardingBloc>(
      () => onboardingModule.onboardingBloc(
        gh<_i1057.CheckOnboardingStatusUseCase>(),
        gh<_i766.SetOnboardingCompleteUseCase>(),
      ),
    );
    return this;
  }
}

class _$SharedPreferencesModule extends _i813.SharedPreferencesModule {}

class _$OnboardingModule extends _i96.OnboardingModule {}
