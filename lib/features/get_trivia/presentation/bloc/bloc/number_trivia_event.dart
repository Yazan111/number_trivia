part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberAsString;

  @override
  List<Object> get props => [numberAsString];

  const GetTriviaForConcreteNumberEvent(this.numberAsString);
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {}
