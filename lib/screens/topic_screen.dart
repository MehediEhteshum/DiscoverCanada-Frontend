import 'package:flutter/material.dart';

import '../widgets/loader_topic_list.dart';

class TopicScreen extends StatelessWidget {
  TopicScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Canada'),
      ),
      body: LoaderTopicList(),
    );
  }
}
