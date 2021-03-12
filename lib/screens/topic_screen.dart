import 'package:flutter/material.dart';

import '../widgets/loader_topic_list.dart';

class TopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Canada"),
      ),
      body: LoaderTopicList(),
    );
  }
}
