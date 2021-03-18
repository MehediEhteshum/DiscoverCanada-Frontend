import 'package:flutter/material.dart';

import './topic.dart';

class SelectedTopic with ChangeNotifier {
  Topic _selectedTopic;

  int get id => _selectedTopic.id;
  String get title => _selectedTopic.title;
  String get imageUrl => _selectedTopic.imageUrl;

  void selectTopic(Topic topic) {
    _selectedTopic = topic;
    notifyListeners();
  }
}
