import 'dart:convert';

import 'package:http/http.dart' as http;

import './base.dart';
import '../models/topic.dart';

Topic topic1 = Topic(id: 1, title: "Test");

Future<void> fetchHomeTopics() async {
  List<Topic> topics = [];
  var homeUrl = "$baseUrl/api/home";
  final response = await http.get(homeUrl);
  print(response.body);
  // final extractedData = json.decode(response.body) as Map<String, dynamic>;
}
