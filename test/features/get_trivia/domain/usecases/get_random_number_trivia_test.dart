import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late final GetRandomNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, triviaDescription: 'test');

  test('getting random number trivia test', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
