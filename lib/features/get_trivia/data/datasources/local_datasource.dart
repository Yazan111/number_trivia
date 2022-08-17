import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class LocalDatasource {
  Future<NumberTriviaModel> getLatestTrivia();
  Future<void> cacheTrivia(NumberTriviaModel numberTriviaModel);
}

const String kLatestTrivia = 'latest_trivia';

class LocalDatasourceSharedPreferences implements LocalDatasource {
  final SharedPreferences sharedPreferences;
  LocalDatasourceSharedPreferences(this.sharedPreferences);

  @override
  Future<void> cacheTrivia(NumberTriviaModel numberTriviaModel) async {
    final triviaEncoded = jsonEncode(numberTriviaModel.toJson());
    final response =
        await sharedPreferences.setString(kLatestTrivia, triviaEncoded);
    if (response == false) {
      throw CacheException();
    }
  }

  @override
  Future<NumberTriviaModel> getLatestTrivia() async {
    final readTrivaiString = sharedPreferences.getString(kLatestTrivia);
    if (readTrivaiString == null) {
      throw CacheException();
    }
    final readTriviaJson = jsonDecode(readTrivaiString);
    return Future.value(NumberTriviaModel.fromJson(readTriviaJson));
  }
}
