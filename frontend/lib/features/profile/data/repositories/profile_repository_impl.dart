import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/exceptions.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';
import 'package:basketvibe/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final profile = await _remoteDataSource.getProfile(userId);
      return Right(profile);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on Exception {
      return const Left(ServerFailure('Failed to load profile'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(
    String userId, {
    required String displayName,
    required String city,
    required String skillLevel,
  }) async {
    try {
      await _remoteDataSource.updateProfile(
        userId,
        displayName: displayName,
        city: city,
        skillLevel: skillLevel,
      );
      return const Right(unit);
    } on Exception {
      return const Left(ServerFailure('Failed to update profile'));
    }
  }
}
