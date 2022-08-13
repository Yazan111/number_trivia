import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure([this.properties = const []]);

  @override
  List<Object?> get props => properties;
}

class CacheFailure extends Failure {
  const CacheFailure([super.properties]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.properties]);
}
