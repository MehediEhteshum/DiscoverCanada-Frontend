import 'package:flutter/material.dart';

import '../helpers/base.dart';

class DownloadExitConfirmationDialog extends StatelessWidget {
  const DownloadExitConfirmationDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build DownloadExitConfirmationDialog");

    return AlertDialog(
      title: const Text(
        "Downloading...",
        softWrap: true,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: fontSize2,
        ),
      ),
      content: const Text(
        "All progress will be lost.\nAre you sure you want to exit?",
        softWrap: true,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: fontSize1,
          color: Colors.red,
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: const TextStyle(fontSize: fontSize1), // fixed dim
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: const TextStyle(fontSize: fontSize1), // fixed dim
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      ],
    );
  }
}
