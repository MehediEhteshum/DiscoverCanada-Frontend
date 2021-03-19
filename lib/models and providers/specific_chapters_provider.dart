import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import './chapter.dart';
import '../helpers/base.dart';

class SpecificChapters with ChangeNotifier {
  List<Chapter> _specificChapters = [];

  List<Chapter> get chaptersList => [..._specificChapters];

  void clearChapters() {
    _specificChapters = [];
    notifyListeners();
  }

  Future<void> fetchAndSetSpecificChapters(
      int topicId, String provinceName) async {
    try {
      var _specificChaptersUrl =
          "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/$topicId/$provinceName/chapters";
      final Response _response = await Dio()
          .get(_specificChaptersUrl)
          .timeout(Duration(seconds: timeOut));
      if (_response.statusCode == successCode) {
        final _extractedData = _response.data;
        final List<Chapter> _loadedChapters = [];
        if (_extractedData["data"] != null) {
          _extractedData["data"].forEach((_chapterObj) => {
                _loadedChapters.add(
                  Chapter(
                    id: _chapterObj["id"],
                    title: _chapterObj["title"],
                  ),
                ),
              });
          _specificChapters = _loadedChapters;
          notifyListeners();
        }
      } else {
        throw ("Error loading data: ${_response.statusCode}");
      }
    } catch (e) {
      throw e;
    }
  }
}
