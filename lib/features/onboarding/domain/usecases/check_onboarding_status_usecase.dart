import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/local_storage/local_storage_service.dart';
import '../../../../core/local_storage/local_storage_keys.dart';

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
