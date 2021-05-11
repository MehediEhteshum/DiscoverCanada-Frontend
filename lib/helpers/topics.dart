import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import './manage_files.dart';
import './manage_image_files.dart';
import '../models and providers/topic.dart';
import './base.dart';

Future<dynamic> fetchTopics(int isOnline) async {
  Future<dynamic> error;

  await _openTopicsBox().then((Box topicsBox) async {
    if (isOnline == 1) {
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
            setTopicImagePathsList();
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
        print("topics1 $e");
        error = Future.error(e.toString());
      }
    } else if (isOnline == 2) {
      // during app start-up, isOnline = null
      topics = []; // assigning temp value to global variable
      throw ("NoError");
    } else {
      // if offline, fetch from device
      setTopicImagePathsList();
      dynamic topicsData = topicsBox.get(0);
      if (topicsData != null) {
        final List<Topic> _topics = _createTopicsList(topicsData);
        topics = [..._topics]; // assigning to global variable
        throw ("NoError");
      } else {
        throw ("EmptyData");
      }
    }
  }).catchError((e) {
    print("topics2 $e");
    error = Future.error(e.toString());
  });

  return error;
}

Future<Box> Function() _openTopicsBox = () async {
  return await Hive.openBox("topics");
};

Future<void> _storeTopicsData(Box topicsBox, dynamic data) async {
  // Hive learning: for storing data, box method e.g. 'put' needs to be used for data persistence on app restart. method on toMap() doesn't keep data on app restart.
  await topicsBox.put(0, data); // storing at default key
  await saveFiles(data, "images", fileTypes[0]);
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
