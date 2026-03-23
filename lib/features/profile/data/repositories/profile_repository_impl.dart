import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';
import 'package:basketvibe/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final profile = await _localDataSource.getProfile(userId);
      return Right(profile);
    } catch (_) {
      return const Left(ServerFailure('Failed to load profile'));
    }
  }
}

