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

  final response = Response(
      statusCode: 200,
      data: fixture('response.json'),
      requestOptions: RequestOptions(path: 'test'));

  setUp(() {
    mockClient = MockDio();
    remoteDatasourceDio = RemoteDatasourceDio(mockClient);
  });

  group('getConcreteNumberTrivia', () {
    test('should fetch normal data when response is 200', () async {
      when(mockClient.get(any)).thenAnswer((_) async => response);
      final result = await remoteDatasourceDio.getConcreteNumberTrivia(tNumber);
      expect(result, tNumberTriviaModel);
    });

    test('should throw network exception when response is not 200', () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => response..statusCode = 401);
      expect(
          () async =>
              await remoteDatasourceDio.getConcreteNumberTrivia(tNumber),
          throwsA(const TypeMatcher<NetworkException>()));
    });
  });
}
