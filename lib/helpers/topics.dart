import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

import '../models/topic.dart';

Future<List<Topic>> fetchTopics() async {
  List<Topic> _topics = [];
  var _topicsUrl =
      "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/topics";
  final _response = await http.get(_topicsUrl);
  if (_response.statusCode == 200) {
    final _extractedData = jsonDecode(_response.body);
    if (_extractedData["data"] != null) {
      _extractedData["data"].forEach((_topicObj) => {
            _topics.add(
              Topic(
                id: _topicObj["id"],
                title: _topicObj["title"],
                imageUrl: _topicObj["image_url"],
              ),
            ),
          });
    }
  } else {
    print("Error loading data");
  }
  return _topics;
}
