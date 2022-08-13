import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

abstract class LocalDatasource {
  Future<NumberTrivia> getLatestTrivia();
  Future<void> cacheTrivia(NumberTriviaModel numberTriviaModel);
}
