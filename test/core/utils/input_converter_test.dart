import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/presentation/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test('will return valid number when the input is valid', () {
      String numberAsString = '1';
      final result = inputConverter.stringToUnsignedInteger(numberAsString);
      expect(result, right(1));
    });

    test('will return invalid input failure when the input is not valid', () {
      String numberAsString = 'dsaca124s';
      final result = inputConverter.stringToUnsignedInteger(numberAsString);
      expect(result, left(InvalidInputFailure()));
    });

    test('will return invalid input failure when the input is negative', () {
      String numberAsString = '-1';
      final result = inputConverter.stringToUnsignedInteger(numberAsString);
      expect(result, left(InvalidInputFailure()));
    });
  });
}
