import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/local_storage/local_storage_service.dart';
import '../../../../core/local_storage/local_storage_keys.dart';

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
