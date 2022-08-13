import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';

abstract class RemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
