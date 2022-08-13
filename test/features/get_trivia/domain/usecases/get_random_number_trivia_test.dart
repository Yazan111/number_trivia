import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late final MockNumberTriviaRepository mockNumberTriviaRepository;
  late final GetRandomNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, triviaDescription: 'test');

  test('getting random number trivia test', () async {
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase();
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
