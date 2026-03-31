import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';

/// Common type aliases for cleaner code
typedef EitherFailure<T> = Future<Either<Failure, T>>;
typedef JsonMap = Map<String, dynamic>;
typedef VoidCallback = void Function();
