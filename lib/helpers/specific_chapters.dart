import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import '../models and providers/chapter.dart';
import 'base.dart';

Future<dynamic> fetchAndSetSpecificChapters(
    bool isOnline, int topicId, String provinceName) async {
  Future<dynamic> error;

  await _openChaptersBox().then((Box chaptersBox) async {
    if (isOnline) {
      // if online, fetch from internet
      try {
        String specificChaptersUrl =
            "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/$topicId/$provinceName/chapters";
        final Response response = await Dio()
            .get(specificChaptersUrl)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == successCode) {
          final extractedData = response.data;
          if (extractedData["data"] != null) {
            await _storeChaptersData(
                chaptersBox, extractedData["data"], topicId, provinceName);
            final List<Chapter> loadedChapters =
                _createChaptersList(extractedData["data"]);
            specificChapters = [...loadedChapters];
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
      dynamic chaptersData = chaptersBox.toMap()[topicId][provinceName];
      if (chaptersData != null) {
        final List<Chapter> chapters = _createChaptersList(chaptersData);
        specificChapters = [...chapters]; // assigning to global variable
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

Future<Box> Function() _openChaptersBox = () async {
  return await Hive.openBox("chapters");
};

Future<void> _storeChaptersData(
    Box chaptersBox, dynamic data, int topicId, String provinceName) async {
  if (!chaptersBox.containsKey(topicId)) {
    // if key doesn't exist, create the key
    await chaptersBox.put(topicId, {});
  }
  await chaptersBox.toMap()[topicId].update(
        provinceName,
        (data) => data,
        ifAbsent: () => data,
      );
}

List<Chapter> _createChaptersList(dynamic data) {
  final List<Chapter> chapters = [];
  data.forEach((chapterObj) => {
        chapters.add(
          Chapter(
            id: chapterObj["id"],
            title: chapterObj["title"],
          ),
        ),
      });
  return chapters;
}

void clearChapters() {
  specificChapters = [];
}
