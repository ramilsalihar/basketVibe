import 'package:equatable/equatable.dart';
import 'package:basketvibe/features/courts/data/models/court_model.dart';
import 'package:basketvibe/features/courts/data/models/sport_type_model.dart';

enum CourtsStatus { initial, loading, loaded, error }

class CourtsState extends Equatable {
  const CourtsState({
    this.status = CourtsStatus.initial,
    this.courts = const [],
    this.sportTypes = const {},
    this.message = '',
    this.pendingOverviewCourt,
  });

  final CourtsStatus status;
  final List<CourtModel> courts;

  /// Keyed by sport type id for quick lookup from a court's sportTypeId.
  final Map<String, SportTypeModel> sportTypes;
  final String message;

  /// A court whose overview sheet should be opened by [CourtFinderPage]
  /// (set when arriving from the home "public places" card). Cleared once
  /// the sheet is shown.
  final CourtModel? pendingOverviewCourt;

  CourtsState copyWith({
    CourtsStatus? status,
    List<CourtModel>? courts,
    Map<String, SportTypeModel>? sportTypes,
    String? message,
    CourtModel? pendingOverviewCourt,
    bool clearPending = false,
  }) {
    return CourtsState(
      status: status ?? this.status,
      courts: courts ?? this.courts,
      sportTypes: sportTypes ?? this.sportTypes,
      message: message ?? this.message,
      pendingOverviewCourt:
          clearPending ? null : (pendingOverviewCourt ?? this.pendingOverviewCourt),
    );
  }

  @override
  List<Object?> get props =>
      [status, courts, sportTypes, message, pendingOverviewCourt];
}
