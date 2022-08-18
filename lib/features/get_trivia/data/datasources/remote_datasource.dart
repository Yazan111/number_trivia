import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';

abstract class RemoteDatasource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class RemoteDatasourceDio implements RemoteDatasource {
  final Dio client;
  RemoteDatasourceDio(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final remoteApi = 'http://numbersapi.com/$number?json';

    final result = await client.get(remoteApi);
    if (result.statusCode != 200) throw NetworkException();

    return NumberTriviaModel.fromJson(jsonDecode(result.data));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    const remoteApi = 'http://numbersapi.com/random?json';

    final result = await client.get(remoteApi);
    if (result.statusCode != 200) throw NetworkException();

    return NumberTriviaModel.fromJson(jsonDecode(result.data));
  }
}
