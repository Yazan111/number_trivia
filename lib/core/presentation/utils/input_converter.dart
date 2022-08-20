import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String input) {
    try {
      final result = int.parse(input);
      if (result < 0) throw const FormatException();
      return right(result);
    } on FormatException catch (_) {
      return left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
