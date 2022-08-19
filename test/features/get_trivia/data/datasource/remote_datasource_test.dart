import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockClient;
  late RemoteDatasourceDio remoteDatasourceDio;
  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(triviaDescription: 'test', number: tNumber);

  setUp(() {
    mockClient = MockDio();
    remoteDatasourceDio = RemoteDatasourceDio(mockClient);
  });

  void testTriviaFetching(String remoteOrConcrete, Function fetchingFunction,
      String remoteApi) async {
    group(remoteOrConcrete, () {
      test(
          'should fetch normal data when response is 200 and request is properly formed ',
          () async {
        when(mockClient.get(any, options: anyNamed('options'))).thenAnswer(
            (_) async => Response(
                requestOptions: RequestOptions(path: 'test'),
                statusCode: 200,
                data: fixture('response.json')));

        // await remoteDatasourceDio.getConcreteNumberTrivia(tNumber);
        final result = await fetchingFunction();
        final captured = verify(
                mockClient.get(captureAny, options: captureAnyNamed('options')))
            .captured;

        expect(result, tNumberTriviaModel);
        expect((captured[0] as String), remoteApi);
        expect((captured[1] as Options).contentType, 'application/json');
      });

      test('should throw network exception when response is not 200', () async {
        when(mockClient.get(any, options: anyNamed('options'))).thenAnswer(
            (_) async => Response(
                requestOptions: RequestOptions(path: 'test'),
                statusCode: 400,
                data: 'error occured'));

        expect(() async => await fetchingFunction(),
            throwsA(const TypeMatcher<NetworkException>()));
      });
    });
  }

  testTriviaFetching(
      'getConcreteNumberTrivia',
      () => remoteDatasourceDio.getConcreteNumberTrivia(tNumber),
      'http://numbersapi.com/$tNumber');

  testTriviaFetching(
      'getRandomNumberTrivia',
      () => remoteDatasourceDio.getRandomNumberTrivia(),
      'http://numbersapi.com/random');
}
