import 'package:flutter/material.dart';

import './error_message.dart';
import '../helpers/base.dart';

class Retry extends StatelessWidget {
  final Function refreshWidget;

  const Retry({Key key, @required this.refreshWidget}) : super(key: key);

  void _retry() {
    refreshWidget();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build Retry");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20), // fixed dim
      child: RefreshIndicator(
        onRefresh: refreshWidget,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // dummy ListView for RefreshIndicator to work
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ErrorIcon,
                const SizedBox(height: 15), // fixed dim
                ErrorTitle,
                const SizedBox(height: 5), // fixed dim
                const ErrorMessage(),
                const SizedBox(height: 15), // fixed dim
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay),
                  label: const Text(
                    "Retry",
                    style: const TextStyle(
                      fontSize: fontSize1, // fixed dim
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: _retry,
                ),
                const Text(
                  "Or",
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.green,
                    ),
                    const Text(
                      "Swipe down to refresh",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize1, // fixed dim
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
