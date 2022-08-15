import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';

import 'package:number_trivia/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomTriviaResponse = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NetworkInfo networkInfo;
  final RemoteDataSource remote;
  final LocalDatasource local;

  NumberTriviaRepositoryImpl({
    required this.networkInfo,
    required this.local,
    required this.remote,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remote.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remote.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomTriviaResponse getConcreteOrRandomTrivia) async {
    final deviceIsConnected = await networkInfo.isConnected;
    if (deviceIsConnected) {
      try {
        final result = await getConcreteOrRandomTrivia();
        local.cacheTrivia(result);
        return right(result);
      } on NetworkException catch (_) {
        return left(const NetworkFailure());
      }
    } else {
      try {
        final result = await local.getLatestTrivia();
        return right(result);
      } on CacheException catch (_) {
        return left(const CacheFailure());
      }
    }
  }
}
