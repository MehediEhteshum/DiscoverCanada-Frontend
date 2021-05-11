import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import './base.dart';

Future<void> saveTopicImage(
    Box box, String filePath, int objId, String url, File file) async {
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, [filePath]);
  } else {
    // 0 key exists. store newFilePath or replace oldFilePath
    List<String> filePathsList = box.get(0);
    if (filePathsList.isEmpty || !filePathsList.asMap().containsKey(objId)) {
      // pathsList empty or no such key yet. so newFilePath
      filePathsList.add(filePath);
    } else {
      // pathsList not empty and key exists. replace oldFilePath
      filePathsList.replaceRange(objId, objId + 1, [filePath]);
    }
    await box.put(0, filePathsList);
  }
  // Hive Learning: get fileData and write file after Hive method 'put' for saving _filePathsList
  final Response response = await Dio()
      .get(
        url,
        options: Options(responseType: ResponseType.bytes),
      )
      .timeout(Duration(seconds: timeOut));
  await file.writeAsBytes(response.data);
}

Future<bool> isNewTopicImage(Box box, String fileId, int objId) async {
  bool isNewFile;
  if (!box.containsKey(1)) {
    // 1 key not exists. so newFile
    isNewFile = true;
    await box.put(1, [fileId]);
  } else {
    // 1 key exists. check if newFile
    List<String> fileIdsToUpdate = box.get(1);
    if (fileIdsToUpdate.isEmpty ||
        !fileIdsToUpdate.asMap().containsKey(objId)) {
      // fileIdsToUpdate empty or no such key yet. so newFile.
      isNewFile = true;
      fileIdsToUpdate.add(fileId);
    } else {
      // fileIdsToUpdate not empty and key exists. check if newFile.
      isNewFile = (fileId != fileIdsToUpdate[objId]);
      if (isNewFile) {
        // replace old fileId
        fileIdsToUpdate.replaceRange(objId, objId + 1, [fileId]);
      }
    }
    await box.put(1, fileIdsToUpdate); // put boxData
  }
  return isNewFile;
}

Future<void> setTopicImagePathsList() async {
  await openTopicImageInfoBox().then((Box topicImageInfoBox) async {
    topicImagePathsList =
        topicImageInfoBox.containsKey(0) ? topicImageInfoBox.get(0) : [];
  });
}

Future<Box> Function() openTopicImageInfoBox = () async {
  return await Hive.openBox("topicImageInfo");
};
