import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const kInvalidInputErrorMessage = 'Invalid input';
const kCacheErrorMessage = 'Cache error';
const kNetworkErrorMessage = 'Network error';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final InputConverter inputConverter;
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;

  NumberTriviaBloc(
      {required this.inputConverter,
      required this.concrete,
      required this.random})
      : super(NumberTriviaIntitialState()) {
    on<GetTriviaForConcreteNumberEvent>(_getTriviaForConcreteNumber);
    on<GetTriviaForRandomNumberEvent>(_getTriviaForRandomNumber);
  }

  FutureOr<void> _getTriviaForConcreteNumber(
      GetTriviaForConcreteNumberEvent event,
      Emitter<NumberTriviaState> emitter) {
    final result = inputConverter.stringToUnsignedInteger(event.numberAsString);

    result.fold(
        (l) => emitter(const NumberTriviaErrorState(kInvalidInputErrorMessage)),
        (r) async {
      emitter(NumberTriviaLoadingState());
      final failureOrTrivia = await concrete(Params(r));
      _emitEitherLoadedOrErrorStates(failureOrTrivia, emitter);
    });
  }

  FutureOr<void> _getTriviaForRandomNumber(GetTriviaForRandomNumberEvent event,
      Emitter<NumberTriviaState> emitter) async {
    emitter(NumberTriviaLoadingState());
    final failureOrTrivia = await random(NoParams());
    _emitEitherLoadedOrErrorStates(failureOrTrivia, emitter);
  }

  FutureOr<void> _emitEitherLoadedOrErrorStates(
      Either<Failure, NumberTrivia> failureOrTrivia,
      Emitter<NumberTriviaState> emitter) {
    failureOrTrivia.fold((l) {
      final message = _mapFailureToMessage(l);
      emitter(NumberTriviaErrorState(message));
    }, (r) {
      emitter(NumberTriviaLoadedState(numberTrivia: r));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return kCacheErrorMessage;

      case NetworkFailure:
        return kNetworkErrorMessage;

      default:
        return 'Unknown error occured';
    }
  }
}
