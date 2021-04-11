import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import '../models and providers/topic.dart';
import './base.dart';

Future<dynamic> fetchTopics(bool isOnline) async {
  Future<dynamic> error;

  await _openTopicsBox().then((Box topicsBox) async {
    if (isOnline) {
      // if online, fetch from internet
      try {
        String topicsUrl =
            "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/topics";
        final Response response =
            await Dio().get(topicsUrl).timeout(Duration(seconds: timeOut));
        if (response.statusCode == successCode) {
          final dynamic extractedData = response.data;
          if (extractedData["data"] != null) {
            await _storeTopicsData(topicsBox, extractedData["data"]);
            final List<Topic> _topics =
                _createTopicsList(extractedData["data"]);
            topics = [..._topics]; // assigning to global variable
            throw ("NoError");
          } else {
            throw ("EmptyData");
          }
        } else {
          throw ("Error loading data: ${response.statusCode}");
        }
      } catch (e) {
        error = Future.error(e.toString());
      }
    } else {
      // if offline, fetch from device
      dynamic topicsData = topicsBox.values.elementAt(0);
      if (topicsData != null) {
        final List<Topic> _topics = _createTopicsList(topicsData);
        topics = [..._topics]; // assigning to global variable
        throw ("NoError");
      } else {
        throw ("EmptyData");
      }
    }
  }).catchError((e) {
    error = Future.error(e.toString());
  });

  return error;
}

Future<Box> Function() _openTopicsBox = () async {
  return await Hive.openBox("topics");
};

Future<void> _storeTopicsData(Box topicsBox, dynamic data) async {
  // learning: for storing data, box method e.g. 'put' needs to be used for data persistence on app restart. method on toMap() doesn't keep data on app restart.
  await topicsBox.put(0, data); // storing at default key
}

List<Topic> _createTopicsList(dynamic data) {
  final List<Topic> _topics = [];
  data.forEach((topicObj) => {
        _topics.add(
          Topic(
            id: topicObj["id"],
            title: topicObj["title"],
            imageUrl: topicObj["image_url"],
            isProvinceDependent: (topicObj["is_province_dependent"] ==
                1), // converting 0, 1 to bool
          ),
        ),
      });
  return _topics;
}
