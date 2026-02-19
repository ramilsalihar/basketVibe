import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class CheckOnboardingStatus extends OnboardingEvent {
  const CheckOnboardingStatus();
}

class CompleteOnboarding extends OnboardingEvent {
  const CompleteOnboarding();
}
