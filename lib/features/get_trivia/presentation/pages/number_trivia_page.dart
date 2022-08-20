import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/get_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/get_trivia/presentation/widgets/loader_widget.dart';
import 'package:number_trivia/features/get_trivia/presentation/widgets/trivia_controls_widget.dart';
import 'package:number_trivia/features/get_trivia/presentation/widgets/trivia_viewer_widget.dart';

import '../widgets/message_widget.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Column(
          children: [
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) => _stateBuilder(context, state),
            ),
            const SizedBox(
              height: 40,
            ),
            TriviaControlsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _stateBuilder(BuildContext context, NumberTriviaState state) {
    if (state is NumberTriviaIntitialState) {
      return const MessageViewerWidget(
        message: 'Start Searching!',
      );
    } else if (state is NumberTriviaErrorState) {
      return MessageViewerWidget(
        message: state.message,
      );
    } else if (state is NumberTriviaLoadingState) {
      return const LoaderWidget();
    } else if (state is NumberTriviaLoadedState) {
      return TriviaViewerWidget(numberTrivia: state.numberTrivia);
    } else {
      return Container();
    }
  }
}
