import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalDatasourceSharedPreferences localDatasource;
  const tNumberTriviaModel =
      NumberTriviaModel(triviaDescription: 'test', number: 1);
  String tTriviaStored = jsonEncode(tNumberTriviaModel.toJson());

  setUp(() async {
    mockSharedPreferences = MockSharedPreferences();
    localDatasource = LocalDatasourceSharedPreferences(mockSharedPreferences);
  });

  group('cacheTrivia', () {
    test('will cache data properly when requested', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      await localDatasource.cacheTrivia(tNumberTriviaModel);
      verify(mockSharedPreferences.setString(any, any));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('will throw cache exception when not able to cache data', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => false);

      expect(() async => localDatasource.cacheTrivia(tNumberTriviaModel),
          throwsA(isA<CacheException>()));

      verify(mockSharedPreferences.setString(any, any));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });

  group('getLatestTrivia', () {
    test('will get the latest trivia if it exists', () async {
      when(mockSharedPreferences.getString(any))
          .thenAnswer((_) => tTriviaStored);

      final result = await localDatasource.getLatestTrivia();
      expect(result, tNumberTriviaModel);
      verify(mockSharedPreferences.getString(any));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('will throw cache exception if it doesn"t find any data', () async {
      when(mockSharedPreferences.getString(any)).thenThrow(CacheException());

      expect(() async => await localDatasource.getLatestTrivia(),
          throwsA(isA<CacheException>()));
    });
  });
}
