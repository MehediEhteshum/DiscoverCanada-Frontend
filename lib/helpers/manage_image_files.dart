import 'package:hive/hive.dart';

import './base.dart';

Future<void> saveTopicImagePath(Box box, String filePath, int objId) async {
  // filePaths are saved at key 0
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, [filePath]);
  } else {
    // 0 key exists. store newFilePath or replace oldFilePath
    List<String> filePathsList = await box.get(0);
    if (filePathsList.isEmpty || !filePathsList.asMap().containsKey(objId)) {
      // pathsList empty or no such key yet. so newFilePath
      filePathsList.add(filePath);
    } else {
      // pathsList not empty and key exists
      // make sure path is unique, then replace oldFilePath
      // filePath = generateUniqueFilePath(filePathsList, objId, filePath);
      filePathsList.replaceRange(objId, objId + 1, [filePath]);
    }
    await box.put(0, filePathsList);
  }
}

String generateUniqueFilePath(
    List<String> filePathsList, int objId, String filePath) {
  final String oldFilePath = filePathsList[objId];
  print("oldFilePath $filePath $oldFilePath $filePathsList $objId");
  if (filePath == oldFilePath) {
    // path is not unique
    final int lastDotId = oldFilePath.lastIndexOf(".");
    final int lastDashId = oldFilePath.lastIndexOf("-ver");
    if (lastDashId == -1) {
      // "-" doesn't exist.
      filePath = oldFilePath.substring(0, lastDotId) +
          "-ver0" +
          oldFilePath.substring(lastDotId);
    } else {
      // "-" exists.
      filePath = oldFilePath.substring(0, lastDashId) +
          oldFilePath.substring(lastDashId + 5);
    }
    print("newFilePath $filePath");
  }
  return filePath;
}

Future<bool> isNewTopicImage(Box box, String fileId, int objId) async {
  bool isNewFile;
  // etags are saved at key 1
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
  // if (isNewFile) {
  //   // delete old file
  //   final bool pathExists = topicImagePathsList.isNotEmpty
  //       // avoiding Error of calling '.length' on []
  //       ? topicImagePathsList.asMap().containsKey(objId)
  //       : false;
  //   if (pathExists) {
  //     final String oldFilePath = topicImagePathsList[objId];
  //     File(oldFilePath).deleteSync(recursive: true);
  //   }
  // }
  return isNewFile;
}

Future<void> setTopicImagePathsList() async {
  await openTopicImageInfoBox().then((Box topicImageInfoBox) async {
    topicImagePathsList =
        topicImageInfoBox.containsKey(0) ? await topicImageInfoBox.get(0) : [];
  });
}

Future<Box> Function() openTopicImageInfoBox = () async {
  return await Hive.openBox("topicImageInfo");
};
