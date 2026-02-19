import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_onboarding_status_usecase.dart';
import '../../domain/usecases/set_onboarding_complete_usecase.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingStatusUseCase _checkOnboardingStatusUseCase;
  final SetOnboardingCompleteUseCase _setOnboardingCompleteUseCase;

  OnboardingBloc({
    required CheckOnboardingStatusUseCase checkOnboardingStatusUseCase,
    required SetOnboardingCompleteUseCase setOnboardingCompleteUseCase,
  })  : _checkOnboardingStatusUseCase = checkOnboardingStatusUseCase,
        _setOnboardingCompleteUseCase = setOnboardingCompleteUseCase,
        super(const OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    final result = await _checkOnboardingStatusUseCase();
    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (hasSeen) {
        if (hasSeen) {
          emit(const OnboardingCompleted());
        } else {
          emit(const OnboardingNotCompleted());
        }
      },
    );
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    final result = await _setOnboardingCompleteUseCase();
    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (_) => emit(const OnboardingCompleted()),
    );
  }
}
