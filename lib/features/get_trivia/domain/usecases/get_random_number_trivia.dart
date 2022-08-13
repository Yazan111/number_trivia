import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call() async {
    return await repository.getRandomNumberTrivia();
  }
}
