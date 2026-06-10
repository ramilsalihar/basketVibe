import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);

  Future<Either<Failure, Unit>> updateProfile(
    String userId, {
    required String displayName,
    required String city,
    required String skillLevel,
  });
}

