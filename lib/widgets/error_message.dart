import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build ErrorMessage");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Don\'t give up! :(',
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const Text(
          'Please check your internet connection or try again later.',
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ],
    );
  }
}
