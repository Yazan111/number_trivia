import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

abstract class UserCase<R, T> {
  Future<Either<Failure, R>> call(T params);
}

class NoParams {}
