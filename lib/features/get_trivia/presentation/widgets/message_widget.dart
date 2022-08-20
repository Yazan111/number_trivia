import 'package:flutter/material.dart';

class MessageViewerWidget extends StatelessWidget {
  final String message;
  const MessageViewerWidget({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
          child: Text(
        message,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
