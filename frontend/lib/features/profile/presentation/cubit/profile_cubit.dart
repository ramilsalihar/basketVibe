import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:basketvibe/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const ProfileInitial());

  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> loadProfile(String userId) async {
    if (userId.isEmpty) {
      emit(const ProfileError('Not signed in'));
      return;
    }
    emit(const ProfileLoading());
    final result = await _getProfileUseCase(GetProfileParams(userId: userId));
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  /// Saves edited fields, then reloads the profile from Firestore.
  Future<void> updateProfile({
    required String userId,
    required String displayName,
    required String city,
    required String skillLevel,
  }) async {
    emit(const ProfileLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        userId: userId,
        displayName: displayName,
        city: city,
        skillLevel: skillLevel,
      ),
    );
    await result.fold(
      (failure) async => emit(ProfileError(failure.message)),
      (_) => loadProfile(userId),
    );
  }
}

