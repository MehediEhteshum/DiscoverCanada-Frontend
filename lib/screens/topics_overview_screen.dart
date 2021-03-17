import 'package:flutter/material.dart';

import '../helpers/base.dart';
import '../widgets/loader_topic_list.dart';

class TopicsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build TopicsOverviewScreen");
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discover Canada",
          softWrap: true,
        ),
      ),
      body: LoaderTopicList(),
    );
  }
}
