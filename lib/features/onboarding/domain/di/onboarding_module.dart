import 'package:injectable/injectable.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:basketvibe/features/onboarding/domain/usecases/set_onboarding_complete_usecase.dart';
import 'package:basketvibe/features/onboarding/presentation/bloc/onboarding_bloc.dart';

@module
abstract class OnboardingModule {
  @injectable
  CheckOnboardingStatusUseCase checkOnboardingStatusUseCase(
    LocalStorageService localStorage,
  ) =>
      CheckOnboardingStatusUseCase(localStorage);

  @injectable
  SetOnboardingCompleteUseCase setOnboardingCompleteUseCase(
    LocalStorageService localStorage,
  ) =>
      SetOnboardingCompleteUseCase(localStorage);

  @injectable
  OnboardingBloc onboardingBloc(
    CheckOnboardingStatusUseCase checkOnboardingStatusUseCase,
    SetOnboardingCompleteUseCase setOnboardingCompleteUseCase,
  ) =>
      OnboardingBloc(
        checkOnboardingStatusUseCase: checkOnboardingStatusUseCase,
        setOnboardingCompleteUseCase: setOnboardingCompleteUseCase,
      );
}
