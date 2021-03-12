import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';

import '../models/topic.dart';
import './base.dart';

Future<dynamic> fetchTopics() async {
  List<Topic> _topics = [];

  try {
    var _topicsUrl =
        "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/topics";
    final Response _response =
        await Dio().get(_topicsUrl).timeout(Duration(seconds: timeOut));
    if (_response.statusCode == successCode) {
      final _extractedData = _response.data;
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
      throw ("Error loading data: ${_response.statusCode}");
    }
  } catch (e) {
    return Future.error(e.toString());
  }

  return [..._topics];
}
