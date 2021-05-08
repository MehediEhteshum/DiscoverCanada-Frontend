import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import '../models and providers/chapter.dart';
import './base.dart';
import './manage_pdf_files.dart';

Future<dynamic> fetchAndSetSpecificChapters(
    int isOnline, int topicId, String provinceName) async {
  Future<dynamic> error;

  await _openChaptersBox().then((Box chaptersBox) async {
    if (isOnline == 1) {
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
        print("specific_chapters1 $e");
        error = Future.error(e.toString());
      }
    } else {
      // if offline, fetch from device
      dynamic chaptersData = chaptersBox.containsKey(topicId)
          ? chaptersBox.get(topicId)[provinceName]
          : null;
      if (chaptersData != null) {
        final List<Chapter> chapters = _createChaptersList(chaptersData);
        specificChapters = [...chapters]; // assigning to global variable
        throw ("NoError");
      } else {
        throw ("EmptyData");
      }
    }
  }).catchError((e) {
    print("specific_chapters2 $e");
    error = Future.error(e.toString());
  });

  return error;
}

Future<Box> Function() _openChaptersBox = () async {
  return await Hive.openBox("chapters");
};

Future<void> _storeChaptersData(
    Box chaptersBox, dynamic data, int topicId, String provinceName) async {
  // learning: for storing data, box method e.g. 'put' needs to be used for data persistence on app restart. method on toMap() doesn't keep data on app restart.
  dynamic updatedData = {provinceName: data};
  if (chaptersBox.containsKey(topicId)) {
    // if key exists, update the current data
    var currentData = await chaptersBox.get(topicId);
    await currentData.update(
      provinceName,
      (data) => data,
      ifAbsent: () => data,
    );
    updatedData = await chaptersBox.get(topicId);
  }
  await chaptersBox.put(topicId, updatedData);
  if (topicIdsContainPdf.contains(topicId)) {
    // only when topicIdContainsPdf
    await savePdfs(data);
  }
}

List<Chapter> _createChaptersList(dynamic data) {
  final List<Chapter> chapters = [];
  data.forEach((chapterObj) => {
        chapters.add(
          Chapter(
            title: chapterObj["title"],
            pdfUrl: chapterObj["pdf_url"],
            webUrl: chapterObj["web_url"],
          ),
        ),
      });
  return chapters;
}

void clearChapters() {
  specificChapters = [];
}
