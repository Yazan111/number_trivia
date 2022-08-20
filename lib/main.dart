import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/get_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'core/presentation/widgets/app_widget.dart';
import 'injection_container.dart' as ic;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.setUp();

  runApp(BlocProvider(
    create: (context) => sl<NumberTriviaBloc>(),
    child: const AppWidget(),
  ));
}
