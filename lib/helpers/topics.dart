import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';

import '../models and providers/topic.dart';
import './base.dart';

Future<dynamic> fetchTopics(bool isOnline) async {
  Future<dynamic> _error;

  if (isOnline) {
    // if online, fetch from internet
    try {
      String _topicsUrl =
          "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/topics";
      final Response _response =
          await Dio().get(_topicsUrl).timeout(Duration(seconds: timeOut));
      if (_response.statusCode == successCode) {
        final _extractedData = _response.data;
        final List<Topic> _topics = [];
        if (_extractedData["data"] != null) {
          _extractedData["data"].forEach((_topicObj) => {
                _topics.add(
                  Topic(
                    id: _topicObj["id"],
                    title: _topicObj["title"],
                    imageUrl: _topicObj["image_url"],
                    isProvinceDependent: (_topicObj["is_province_dependent"] ==
                        1), // converting 0, 1 to bool
                  ),
                ),
              });
          topics = [..._topics];
          throw ("NoError");
        }
      } else {
        throw ("Error loading data: ${_response.statusCode}");
      }
    } catch (e) {
      _error = Future.error(e.toString());
    }
  } else {
    // if offline, fetch from device
    _error = Future.error("NoInternet");
  }

  return _error;
}
