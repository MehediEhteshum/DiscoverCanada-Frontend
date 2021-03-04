import 'package:flutter/material.dart';

import './error_message.dart';

class ErrorMessageDialog extends StatelessWidget {
  const ErrorMessageDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: <Widget>[
          const Icon(
            Icons.warning,
            size: 50,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            "ERROR 404: Content not found",
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
      content: ErrorMessage(),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 17),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
