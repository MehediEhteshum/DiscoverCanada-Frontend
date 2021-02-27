import 'package:flutter/material.dart';

import '../widgets/topic_list_loader.dart';

class TopicScreen extends StatelessWidget {
  TopicScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Canada'),
      ),
      body: TopicListLoader(),
    );
  }
}
