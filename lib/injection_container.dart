import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/get_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/get_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/get_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/get_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/presentation/utils/input_converter.dart';

final sl = GetIt.instance;

// created for every feature.

Future<void> setUp() async {
  //! External
  // dio, sharedpreferences, connectivity
  sl.registerSingleton<Dio>(Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<Connectivity>(Connectivity());

  //! cores
  sl.registerSingleton<NetworkInfo>(NetworkInfoConnectivity(sl()));
  sl.registerSingleton<InputConverter>(InputConverter());

  // datasources
  sl.registerSingleton<LocalDatasource>(LocalDatasourceSharedPreferences(sl()));
  sl.registerSingleton<RemoteDatasource>(RemoteDatasourceDio(sl()));

  //! features
  // repositories
  sl.registerSingleton<NumberTriviaRepository>(NumberTriviaRepositoryImpl(
    networkInfo: sl(),
    local: sl(),
    remote: sl(),
  ));

  // usecases
  sl.registerSingleton<GetConcreteNumberTrivia>(GetConcreteNumberTrivia(sl()));
  sl.registerSingleton<GetRandomNumberTrivia>(GetRandomNumberTrivia(sl()));

  // bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      inputConverter: sl(),
      concrete: sl(),
      random: sl(),
    ),
  );
}
