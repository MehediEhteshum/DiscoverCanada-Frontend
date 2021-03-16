import 'package:flutter/material.dart';

import '../widgets/loader_topic_list.dart';

class TopicsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build TopicsOverviewScreen");
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
