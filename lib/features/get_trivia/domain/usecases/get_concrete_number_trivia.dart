import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/get_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

class GetConcreteNumberTrivia extends UserCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params {
  final int number;
  Params(this.number);
}
