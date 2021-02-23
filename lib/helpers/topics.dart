import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

import '../models/topic.dart';

Topic topic1 = Topic(id: 1, title: "Test");

Future<void> fetchHomeTopics() async {
  List<Topic> topics = [];
  var homeUrl = "${FlutterConfig.get('BASE_URL')}/api/home";
  final response = await http.get(homeUrl);
  print(response.body);
  // final extractedData = json.decode(response.body) as Map<String, dynamic>;
}
