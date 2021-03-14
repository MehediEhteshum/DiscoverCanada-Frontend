import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models and providers/selected_topic_provider.dart';

class ChaptersOverviewScreen extends StatelessWidget {
  static const routeName = "/chapters";

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapters'),
      ),
      body: Consumer<SelectedTopic>(
        builder: (ctx, selectedTopic, _) {
          return Text(
            "${selectedTopic.title}",
            softWrap: true,
          );
        },
      ),
    );
  }
}
