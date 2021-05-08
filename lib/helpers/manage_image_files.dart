import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import './base.dart';
import './manage_files.dart';

Future<void> saveTopicImages(dynamic data) async {
  String folderPath = appDocDir.path + "/" + "images" + "/";
  data.forEach((obj) async {
    try {
      String imageUrl = FlutterConfig.get('BASE_URL') + obj["image_url"];
      bool isNewFile = await _isNewFile(imageUrl, obj["id"]);
      if (isNewFile) {
        // new file, so store in device
        RegExp fileNameRegExp = RegExp(r"\w*\d*\.\w*");
        String fileName = fileNameRegExp.stringMatch(obj["image_url"]);
        String filePath = folderPath + fileName;
        File file = File(filePath);
        await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
          List<String> _filePathsList =
              topicImageInfoBox.containsKey(0) ? topicImageInfoBox.get(0) : [];
          if (_filePathsList.isEmpty ||
              !_filePathsList.asMap().containsKey(obj["id"] - 1)) {
            // pathsList empty or no current key yet
            _filePathsList.add(filePath);
          } else {
            // replace old path
            _filePathsList.replaceRange(obj["id"] - 1, obj["id"], [filePath]);
          }
          await topicImageInfoBox.put(0, _filePathsList);
          // Hive Learning: avoid generate items to be saved after await i.e. make sure you have data ready before calling Hive method 'put'
          final Response response = await Dio()
              .get(
                imageUrl,
                options: Options(responseType: ResponseType.bytes),
              )
              .timeout(Duration(seconds: timeOut));
          await file.writeAsBytes(response.data);
        });
      }
    } catch (e) {
      print("manage_image_files1 $e");
    }
  });
}

Future<bool> _isNewFile(String url, int objId) async {
  try {
    final Response testResponse = await Dio()
        .head(
          url,
          options: Options(responseType: ResponseType.stream),
        )
        .timeout(Duration(seconds: timeOut));
    String fileId = testResponse.headers.value("etag");
    bool isNewFile =
        await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
      List<String> savedFileIds = topicImageInfoBox.get(1);
      if (savedFileIds != null) {
        if (savedFileIds.asMap().containsKey(objId - 1)) {
          bool isNewFile = (fileId != savedFileIds[objId - 1]);
          if (isNewFile) {
            // replace old fileId
            savedFileIds.replaceRange(objId - 1, objId, [fileId]);
            await topicImageInfoBox.put(1, savedFileIds);
          }
          return (isNewFile);
        } else {
          savedFileIds.add(fileId); // as the key i.e. value doesn't exist yet
          await topicImageInfoBox.put(1, savedFileIds);
          return true;
        }
      } else {
        await topicImageInfoBox
            .put(1, [fileId]); // savedFileIds == null means first time
        return true;
      }
    });
    return isNewFile;
  } catch (e) {
    print("manage_image_files2 $e");
    return false;
  }
}

Future<void> setTopicImagesPathsList() async {
  await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
    topicImagePathsList = topicImageInfoBox.get(0);
  });
}

Future<Box> Function() _openTopicImageInfoBox = () async {
  return await Hive.openBox("topicImageInfo");
};
