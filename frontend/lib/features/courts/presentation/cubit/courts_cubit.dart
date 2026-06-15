import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/features/courts/data/datasources/court_remote_datasource.dart';
import 'package:basketvibe/features/courts/data/datasources/sport_type_remote_datasource.dart';
import 'package:basketvibe/features/courts/data/models/court_model.dart';
import 'package:basketvibe/features/courts/presentation/cubit/courts_state.dart';

class CourtsCubit extends Cubit<CourtsState> {
  CourtsCubit(this._courtsDataSource, this._sportTypesDataSource)
      : super(const CourtsState());

  final CourtRemoteDataSource _courtsDataSource;
  final SportTypeRemoteDataSource _sportTypesDataSource;

  Future<void> loadCourts() async {
    emit(state.copyWith(status: CourtsStatus.loading));
    try {
      final courts = await _courtsDataSource.getCourts();
      final sportTypes = await _sportTypesDataSource.getSportTypes();
      if (isClosed) return;
      emit(state.copyWith(
        status: CourtsStatus.loaded,
        courts: courts,
        sportTypes: {for (final s in sportTypes) s.id: s},
      ));
    } on Exception catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CourtsStatus.error,
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Asks [CourtFinderPage] to open the overview sheet for [court].
  void requestOverview(CourtModel court) {
    emit(state.copyWith(pendingOverviewCourt: court));
  }

  /// Called once the sheet has been shown.
  void clearOverviewRequest() {
    emit(state.copyWith(clearPending: true));
  }
}
