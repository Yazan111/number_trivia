import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/number_trivia_bloc.dart';

class TriviaControlsWidget extends StatefulWidget {
  TriviaControlsWidget({Key? key}) : super(key: key);

  @override
  State<TriviaControlsWidget> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControlsWidget> {
  final TextEditingController _controller = TextEditingController();
  String _triviaNumber = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: 50,
          child: TextField(
            controller: _controller,
            onChanged: (input) {
              _triviaNumber = input;
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter positive integer...'),
          )),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    BlocProvider.of<NumberTriviaBloc>(context)
                        .add(GetTriviaForRandomNumberEvent());
                  },
                  child: const Text('Random Trivia')),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    BlocProvider.of<NumberTriviaBloc>(context)
                        .add(GetTriviaForConcreteNumberEvent(_triviaNumber));
                  },
                  child: const Text('Concrete Trivia')),
            ),
          ),
        ],
      )
    ]);
  }
}
