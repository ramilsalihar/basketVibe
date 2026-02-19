import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // Log bloc creation if needed
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Log state changes if needed (only in debug mode)
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Log errors if needed
    // In production, you might want to send errors to a crash reporting service
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // Log bloc disposal if needed
  }
}
