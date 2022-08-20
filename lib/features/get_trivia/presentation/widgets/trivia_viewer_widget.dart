import 'package:flutter/material.dart';
import 'package:number_trivia/features/get_trivia/domain/entities/number_trivia.dart';

class TriviaViewerWidget extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const TriviaViewerWidget({required this.numberTrivia, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            numberTrivia.number.toString(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            numberTrivia.triviaDescription,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          )
        ]));
  }
}
