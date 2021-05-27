import 'package:flutter/material.dart';

import '../helpers/base.dart';

class DownloadProgressContainer extends StatelessWidget {
  const DownloadProgressContainer({
    Key key,
    @required double downloadProgress,
  })  : _downloadProgress = downloadProgress,
        super(key: key);

  final double _downloadProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LinearProgressIndicator(
            value: _downloadProgress,
            backgroundColor: Colors.grey[300],
            color: Colors.black,
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Make sure you have internet access.",
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: fontSize1,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Please wait. Download may take several minutes to finish.",
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: fontSize1,
            ),
          ),
        ],
      ),
    );
  }
}
