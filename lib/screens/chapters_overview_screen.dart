import 'package:flutter/material.dart';

import '../widgets/selection_info_container.dart';

class ChaptersOverviewScreen extends StatelessWidget {
  static const routeName = "/chapters";

  @override
  Widget build(BuildContext _) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chapters",
            softWrap: true,
          ),
        ),
        body: Column(
          children: <Widget>[
            SelectionInfoContainer(),
            const Text(
              "Chapters Grid",
              softWrap: true,
            ),
          ],
        ));
  }
}
