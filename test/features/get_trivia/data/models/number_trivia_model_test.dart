import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tNumberTriviaModel =
      NumberTriviaModel(number: 1, triviaDescription: 'test');

  test('number trivia model is a number trivia', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('''should return a valid model when dealing with integer 
        number trivia json''', () {
      final responseString = fixture('trivia_int.json');
      final responseJson = jsonDecode(responseString);
      final result = NumberTriviaModel.fromJson(responseJson);
      expect(result, tNumberTriviaModel);
    });

    test('''should return a valid model when dealing with double
        number trivia json''', () {
      final responseString = fixture('trivia_double.json');
      final responseJson = jsonDecode(responseString);
      final result = NumberTriviaModel.fromJson(responseJson);
      expect(result, tNumberTriviaModel);
    });
  });

  test('toJson method should return a valid json', () {
    final resultJson = {
      'number': 1,
      'text': 'test',
    };

    final jsonModel = tNumberTriviaModel.toJson();
    expect(jsonModel, resultJson);
  });
}
