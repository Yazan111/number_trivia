import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/presentation/utils/input_converter.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/get_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc.mocks.dart';

@GenerateMocks([InputConverter, GetConcreteNumberTrivia, GetRandomNumberTrivia])
void main() {
  late MockInputConverter mockInputConverter;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late NumberTriviaBloc numberTriviaBloc;

  const tNumberParsed = 1;
  const tNumberTrivia =
      NumberTrivia(triviaDescription: 'test', number: tNumberParsed);

  setUp(() {
    EquatableConfig.stringify = true;
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    numberTriviaBloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  initializeConcreteNumberTriviaWithValue(Either<Failure, NumberTrivia> value) {
    when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => value);
  }

  initializeRandomNumberTriviaWithValue(Either<Failure, NumberTrivia> value) {
    when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => value);
  }

  initializeInputConverterWithValue(Either<Failure, int> value) {
    when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(value);
  }

  group('getTriviaForConcreteNumberEvent', () {
    const tInvalidInput = 'dsads';
    const tNumberString = '1';

    test('should emit initial state when starting the app', () {
      expect(numberTriviaBloc.state, equals(NumberTriviaIntitialState()));
    });

    test(
        'should call input conversion correctly when submitting concrete trivia event',
        () async {
      initializeInputConverterWithValue(right(tNumberParsed));
      initializeConcreteNumberTriviaWithValue(right(tNumberTrivia));

      numberTriviaBloc
          .add(const GetTriviaForConcreteNumberEvent(tNumberString));

      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should return error string when input conversion fails', () async {
      initializeInputConverterWithValue(left(InvalidInputFailure()));
      final states = [const NumberTriviaErrorState(kInvalidInputErrorMessage)];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc
          .add(const GetTriviaForConcreteNumberEvent(tInvalidInput));
    });

    test('should call usecase with correct parameter', () async {
      initializeInputConverterWithValue(right(tNumberParsed));
      initializeConcreteNumberTriviaWithValue(right(tNumberTrivia));

      numberTriviaBloc
          .add(const GetTriviaForConcreteNumberEvent(tInvalidInput));

      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia.call(const Params(tNumberParsed)));
    });

    test('should return loading followed by success when call succeed',
        () async {
      initializeInputConverterWithValue(right(tNumberParsed));
      initializeConcreteNumberTriviaWithValue(right(tNumberTrivia));

      final states = [
        NumberTriviaLoadingState(),
        const NumberTriviaLoadedState(numberTrivia: tNumberTrivia),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc
          .add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test(
        'should return loading followed by caching error when call is unsucceed',
        () async {
      initializeInputConverterWithValue(right(tNumberParsed));
      initializeConcreteNumberTriviaWithValue(left(const CacheFailure()));

      final states = [
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(kCacheErrorMessage),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc
          .add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test(
        'should return loading followed by network error when call is unsucceed',
        () async {
      initializeInputConverterWithValue(right(tNumberParsed));
      initializeConcreteNumberTriviaWithValue(left(const NetworkFailure()));

      final states = [
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(kNetworkErrorMessage),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc
          .add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });
  group('getTriviaForRandomNumber', () {
    test('should call usecase with correct parameter', () async {
      initializeRandomNumberTriviaWithValue(right(tNumberTrivia));

      numberTriviaBloc.add(GetTriviaForRandomNumberEvent());

      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia.call(NoParams()));
    });

    test('should return loading followed by success when call succeed',
        () async {
      initializeRandomNumberTriviaWithValue(right(tNumberTrivia));

      final states = [
        NumberTriviaLoadingState(),
        const NumberTriviaLoadedState(numberTrivia: tNumberTrivia),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc.add(GetTriviaForRandomNumberEvent());
    });

    test(
        'should return loading followed by caching error when call is unsucceed',
        () async {
      initializeRandomNumberTriviaWithValue(left(const CacheFailure()));

      final states = [
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(kCacheErrorMessage),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc.add(GetTriviaForRandomNumberEvent());
    });

    test(
        'should return loading followed by network error when call is unsucceed',
        () async {
      initializeRandomNumberTriviaWithValue(left(const NetworkFailure()));

      final states = [
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(kNetworkErrorMessage),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(states));

      numberTriviaBloc.add(GetTriviaForRandomNumberEvent());
    });
  });

  tearDown(() async {
    await numberTriviaBloc.close();
  });
}
