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
        softWrap: true,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: Column(
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
      ),
      actions: <Widget>[
        FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(
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
