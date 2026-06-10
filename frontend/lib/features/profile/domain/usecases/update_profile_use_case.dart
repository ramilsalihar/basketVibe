import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, Unit>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      params.userId,
      displayName: params.displayName,
      city: params.city,
      skillLevel: params.skillLevel,
    );
  }
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    required this.userId,
    required this.displayName,
    required this.city,
    required this.skillLevel,
  });

  final String userId;
  final String displayName;
  final String city;
  final String skillLevel;

  @override
  List<Object?> get props => [userId, displayName, city, skillLevel];
}
