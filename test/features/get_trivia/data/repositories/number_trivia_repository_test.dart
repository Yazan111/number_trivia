import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/get_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'number_trivia_repository_test.mocks.dart';

@GenerateMocks([NetworkInfo, LocalDatasource, RemoteDataSource])
void main() {
  late NumberTriviaRepositoryImpl repository;
  final mockNetworkInfo = MockNetworkInfo();
  final mockRemoteDataSource = MockRemoteDataSource();
  final mockLocalDataSource = MockLocalDatasource();

  const tNumber = 1;
  const tNumberTriviaModel = NumberTriviaModel(
    triviaDescription: 'test',
    number: tNumber,
  );

  setUp(() {
    repository = NumberTriviaRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  makeHappyScenario(Function concreteOrRandomApi, MockLocalDatasource local,
      MockNetworkInfo networkInfo) {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(concreteOrRandomApi()).thenAnswer((_) async => tNumberTriviaModel);
    when(mockLocalDataSource.cacheTrivia(any)).thenAnswer((_) async => {});
  }

  resetAllMocks() {
    reset(mockNetworkInfo);
    reset(mockLocalDataSource);
    reset(mockRemoteDataSource);
  }

  testTrivia(Function concreteOrRandomTriviaRemote,
      Function concreteOrRandomTriviaRepo, String triviaGroup) {
    group(triviaGroup, () {
      // happy scenario.
      makeHappyScenario(
          concreteOrRandomTriviaRemote, mockLocalDataSource, mockNetworkInfo);

      test('should check for connection', () async {
        await concreteOrRandomTriviaRepo();
        verify(mockNetworkInfo.isConnected);
      });

      group('device is online', () {
        setUp(() {
          resetAllMocks();
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        test(
            'should return remote data when the call to remote data source is successful',
            () async {
          when(concreteOrRandomTriviaRemote())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(mockLocalDataSource.cacheTrivia(any))
              .thenAnswer((_) async => {});
          final response = await concreteOrRandomTriviaRepo();
          expect(response, const Right(tNumberTriviaModel));

          verify(concreteOrRandomTriviaRemote()).called(1);
          verify(mockLocalDataSource.cacheTrivia(tNumberTriviaModel)).called(1);
        });
        test(
            'should return a network failure when call to remote datasource is unsuccessful',
            () async {
          when(concreteOrRandomTriviaRemote()).thenThrow(NetworkException());
          final result = await concreteOrRandomTriviaRepo();
          expect(result, const Left(NetworkFailure()));
        });

        test('should cache trivia when getting trivia online', () async {
          when(concreteOrRandomTriviaRemote())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(mockLocalDataSource.cacheTrivia(any))
              .thenAnswer((_) async => {});
          await concreteOrRandomTriviaRepo();
          verify(mockLocalDataSource.cacheTrivia(tNumberTriviaModel)).called(1);
        });
      });
      group('device is offline', () {
        setUp(() {
          resetAllMocks();
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should get the lattest trivia when its available', () async {
          when(mockLocalDataSource.getLatestTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          final result = await concreteOrRandomTriviaRepo();
          expect(result, right(tNumberTriviaModel));
          verify(mockLocalDataSource.getLatestTrivia()).called(1);
          verifyZeroInteractions(mockRemoteDataSource);
        });

        test('should get cache failure when there is no data in cache',
            () async {
          when(mockLocalDataSource.getLatestTrivia())
              .thenThrow(CacheException());
          final result = await concreteOrRandomTriviaRepo();
          expect(result, left(const CacheFailure()));
          verify(mockLocalDataSource.getLatestTrivia()).called(1);
          verifyZeroInteractions(mockRemoteDataSource);
        });
      });
    });
  }

  testTrivia(() => mockRemoteDataSource.getConcreteNumberTrivia(any),
      () => repository.getConcreteNumberTrivia(tNumber), 'concrete trivia');

  testTrivia(() => mockRemoteDataSource.getRandomNumberTrivia(),
      () => repository.getRandomNumberTrivia(), 'random trivia');
}
