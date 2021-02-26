import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

import '../models/topic.dart';

Future<List<Topic>> fetchTopics() async {
  List<Topic> topics = [];
  var topicsUrl =
      "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/topics";
  final response = await http.get(topicsUrl);
  if (response.statusCode == 200) {
    final extractedData = jsonDecode(response.body);
    if (extractedData["data"] != null) {
      extractedData["data"].forEach((topicObj) => {
            topics.add(
              Topic(
                id: topicObj["id"],
                title: topicObj["title"],
                imageUrl: topicObj["image_url"],
              ),
            ),
          });
    }
  } else {
    print("Error loading data");
  }
  return topics;
}
