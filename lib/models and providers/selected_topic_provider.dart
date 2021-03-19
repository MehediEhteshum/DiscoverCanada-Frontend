import 'package:flutter/material.dart';

import './topic.dart';

class SelectedTopic with ChangeNotifier {
  Topic _selectedTopic;

  int get topicId => _selectedTopic.id;
  String get topicTitle => _selectedTopic.title;
  String get topicImageUrl => _selectedTopic.imageUrl;

  void selectTopic(Topic topic) {
    _selectedTopic = topic;
    notifyListeners();
  }
}
