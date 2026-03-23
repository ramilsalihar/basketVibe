import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfileUseCase) : super(const ProfileInitial());

  final GetProfileUseCase _getProfileUseCase;

  Future<void> loadProfile(String userId) async {
    emit(const ProfileLoading());
    final result = await _getProfileUseCase(GetProfileParams(userId: userId));
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}

