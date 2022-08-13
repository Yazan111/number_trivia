import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String triviaDescription;
  final int number;

  const NumberTrivia({
    required this.triviaDescription,
    required this.number,
  });

  @override
  List<Object?> get props => [triviaDescription, number];
}
