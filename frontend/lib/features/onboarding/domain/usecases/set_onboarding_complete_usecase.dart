import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';

class SetOnboardingCompleteUseCase {
  final LocalStorageService _localStorage;

  SetOnboardingCompleteUseCase(this._localStorage);

  Future<Either<Failure, void>> call() async {
    try {
      await _localStorage.setBool(LocalStorageKeys.hasSeenOnboarding, true);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save onboarding status'));
    }
  }
}
