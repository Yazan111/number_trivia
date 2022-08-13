import '../models/number_trivia_model.dart';

abstract class LocalDatasource {
  Future<NumberTriviaModel> getLatestTrivia();
  Future<void> cacheTrivia(NumberTriviaModel numberTriviaModel);
}
