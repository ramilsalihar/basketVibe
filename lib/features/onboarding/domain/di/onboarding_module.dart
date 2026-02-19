import 'package:injectable/injectable.dart';
import '../../../../core/local_storage/local_storage_service.dart';
import '../usecases/check_onboarding_status_usecase.dart';
import '../usecases/set_onboarding_complete_usecase.dart';
import '../../presentation/bloc/onboarding_bloc.dart';

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
