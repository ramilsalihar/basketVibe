import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';

class CheckOnboardingStatusUseCase {
  final LocalStorageService _localStorage;

  CheckOnboardingStatusUseCase(this._localStorage);

  Future<Either<Failure, bool>> call() async {
    try {
      final hasSeen = await _localStorage.getBool(
        LocalStorageKeys.hasSeenOnboarding,
        defaultValue: false,
      );
      return Right(hasSeen);
    } catch (e) {
      return Left(CacheFailure('Failed to check onboarding status'));
    }
  }
}
