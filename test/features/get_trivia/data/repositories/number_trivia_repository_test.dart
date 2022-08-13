import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/get_trivia/data/repositories/number_trivia_repository_impl.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockRemoteDatasource extends Mock implements RemoteDataSource {}

class MockLocalDatasource extends Mock implements LocalDatasource {}

void main() {
  late final MockNetworkInfo mockNetworkInfo;
  late final MockLocalDatasource mockLocalDataSource;
  late final MockRemoteDatasource mockRemoteDataSource;
  late final NumberTriviaRepositoryImpl repository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDatasource();
    mockRemoteDataSource = MockRemoteDatasource();
    repository = NumberTriviaRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia ', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      triviaDescription: 'test',
      number: tNumber,
    );
    final tNumberTrivia = tNumberTriviaModel;

    test('should check if there is a connection', () {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when response is success', () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        final response = await repository.getConcreteNumberTrivia(tNumber);
        expect(response, right(tNumberTriviaModel));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });

      test('should return server failure when response is unsuccess', () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(NetworkException());
        final response = await repository.getConcreteNumberTrivia(tNumber);
        expect(response, left(const NetworkFailure()));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });
    });

    group('device is offline ', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return the latest trivia when there is any', () async {
        when(() => mockLocalDataSource.getLatestTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);
        expect(result, right(tNumberTriviaModel));
        verify(() => mockLocalDataSource.getLatestTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
      });

      test('should return cache failure when there is none ', () async {
        when(() => mockLocalDataSource.getLatestTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);
        expect(result, left(const CacheFailure()));
        verify(() => mockLocalDataSource.getLatestTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
}
