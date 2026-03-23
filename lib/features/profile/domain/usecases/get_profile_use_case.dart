import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';
import 'package:basketvibe/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileEntity>> call(GetProfileParams params) {
    return _repository.getProfile(params.userId);
  }
}

class GetProfileParams extends Equatable {
  const GetProfileParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

