import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import './base.dart';
import './manage_files.dart' as mf;

Future<void> saveTopicImages(dynamic data) async {
  String folderPath = mf.appDocDir.path + "/" + "images" + "/";
  data.forEach((obj) async {
    try {
      String imageUrl = FlutterConfig.get('BASE_URL') + obj["image_url"];
      int objId = obj["id"] - 1; // topicIndex = topicId - 1
      bool isNewFile = await mf.isNewFile(
          imageUrl, objId, _openTopicImageInfoBox, "topicImage");
      if (isNewFile) {
        // new file, so store in device
        RegExp fileNameRegExp = RegExp(r"\w*\d*\.\w*");
        String fileName = fileNameRegExp.stringMatch(obj["image_url"]);
        String filePath = folderPath + fileName;
        File file = File(filePath);
        await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
          if (!topicImageInfoBox.containsKey(0)) {
            // 0 key not exists. so newFilePath
            await topicImageInfoBox.put(0, [filePath]);
          } else {
            // 0 key exists. store newFilePath or replace oldFilePath
            List<String> filePathsList = topicImageInfoBox.get(0);
            if (filePathsList.isEmpty ||
                !filePathsList.asMap().containsKey(objId)) {
              // pathsList empty or no such key yet. so newFilePath
              filePathsList.add(filePath);
            } else {
              // pathsList not empty and key exists. replace oldFilePath
              filePathsList.replaceRange(objId, objId + 1, [filePath]);
            }
            await topicImageInfoBox.put(0, filePathsList);
          }
          // Hive Learning: get fileData and write file after Hive method 'put' for saving _filePathsList
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

Future<void> setTopicImagesPathsList() async {
  await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
    topicImagePathsList = topicImageInfoBox.get(0);
  });
}

Future<Box> Function() _openTopicImageInfoBox = () async {
  return await Hive.openBox("topicImageInfo");
};
