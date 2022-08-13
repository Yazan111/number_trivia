import 'package:dartz/dartz.dart';
import 'package:number_trivia/features/get_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call(int number) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
