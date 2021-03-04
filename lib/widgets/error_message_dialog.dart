import 'package:flutter/material.dart';

import './error_message.dart';
import '../helpers/base.dart';

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
          ErrorTitle,
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
