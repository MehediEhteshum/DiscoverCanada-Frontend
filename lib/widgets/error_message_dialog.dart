import 'package:flutter/material.dart';

import '../helpers/base.dart';
import './error_message.dart';

class ErrorMessageDialog extends StatelessWidget {
  const ErrorMessageDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build ErrorMessageDialog");
    return AlertDialog(
      title: Column(
        children: <Widget>[
          ErrorIcon,
          const SizedBox(height: 20), // fixed dim
          ErrorTitle,
        ],
      ),
      content: ErrorMessage(),
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0), // fixed dim
      actions: <Widget>[
        TextButton(
          child: Text(
            'Close',
            style: TextStyle(fontSize: fontSize1), // fixed dim
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
