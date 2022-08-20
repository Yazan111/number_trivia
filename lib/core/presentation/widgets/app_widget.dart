import 'package:flutter/material.dart';
import 'package:number_trivia/features/get_trivia/presentation/pages/number_trivia_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia Applciation',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
        ),
        body: const NumberTriviaPage(),
      ),
    );
  }
}
