import 'package:flutter/material.dart';

class ErrorMessageDialog extends StatelessWidget {
  const ErrorMessageDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "ERROR 404: Content not found",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Something went wrong! :('),
          const Text('Please check your internet connection.'),
        ],
      ),
    );
  }
}
