import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late final MockNumberTriviaRepository mockNumberTriviaRepository;
  late final GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, triviaDescription: 'test');
  test('calling get concrete number trivia usecase will return a number trivia',
      () async {
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(Params(tNumber));
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
