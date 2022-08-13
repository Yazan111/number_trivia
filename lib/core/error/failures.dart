import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final properties;

  const Failure(this.properties);

  @override
  List<Object?> get props => properties;
}
