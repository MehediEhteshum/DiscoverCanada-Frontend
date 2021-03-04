import 'package:flutter/material.dart';

import './error_message.dart';

class Retry extends StatelessWidget {
  final String routeToReload;

  const Retry({Key key, @required this.routeToReload}) : super(key: key);

  void _retry(BuildContext context) {
    Navigator.pop(context); // pop current page
    Navigator.pushNamed(context, routeToReload);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.warning,
          size: 50,
          color: Colors.red,
        ),
        const SizedBox(height: 15),
        const Text(
          "ERROR 404: Content not found",
          textAlign: TextAlign.center,
          softWrap: true,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 5),
        const ErrorMessage(),
        const SizedBox(height: 15),
        ElevatedButton.icon(
          icon: const Icon(Icons.replay),
          label: const Text("Retry"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          ),
          onPressed: () => _retry(context),
        ),
      ],
    );
  }
}
