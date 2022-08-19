part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaIntitialState extends NumberTriviaState {}

class NumberTriviaLoadingState extends NumberTriviaState {}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  @override
  List<Object> get props => [numberTrivia];

  const NumberTriviaLoadedState({required this.numberTrivia});
}

class NumberTriviaErrorState extends NumberTriviaState {
  final String message;

  @override
  List<Object> get props => [message];

  const NumberTriviaErrorState(this.message);
}
