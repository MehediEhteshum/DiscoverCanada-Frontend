import 'package:flutter/material.dart';

class ChapterScreen extends StatelessWidget {
  static const routeName = "/chapters";

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter'),
      ),
      body: Text("chapters"),
    );
  }
}
