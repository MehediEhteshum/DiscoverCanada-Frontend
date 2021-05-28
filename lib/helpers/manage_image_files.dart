import 'package:hive/hive.dart';

import './base.dart';

Future<void> saveTopicImagePath(Box box, String filePath, int objId) async {
  Map boxData;
  // filePaths are saved at key 0
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, {objId: filePath});
  } else {
    // 0 key exists. store newFilePath or replace oldFilePath
    boxData = await box.get(0);
    if (!boxData.containsKey(objId)) {
      // topic key not exists. so newFilePath
      await boxData.putIfAbsent(
        objId,
        () => filePath,
      ); // update boxData
    } else {
      // topic key exists, replace oldFilePath
      // make sure path is unique, then replace oldFilePath
      // filePath = generateUniqueFilePath(filePathsList, objId, filePath);
      await boxData.update(
        objId,
        (curr) => filePath,
        ifAbsent: () => filePath,
      ); // update boxData
    } // update boxData
    // Hive learning: need to put again for data persistence on app restart
    await box.put(0, boxData); // put boxData
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
  Map boxData;
  bool isNewFile;
  // etags are saved at key 1
  if (!box.containsKey(1)) {
    // 1 key not exists. so newFile
    isNewFile = true;
    await box.put(1, {objId: fileId});
  } else {
    // 1 key exists. check if newFile
    boxData = await box.get(1);
    if (!boxData.containsKey(objId)) {
      // topic key not exists. so newFile
      isNewFile = true;
      await boxData.putIfAbsent(
        objId,
        () => fileId,
      ); // update boxData
    } else {
      // topic key exists. check if newFile.
      isNewFile = (fileId != boxData[objId]);
      if (isNewFile) {
        // replace old fileId
        await boxData.update(
          objId,
          (curr) => fileId,
          ifAbsent: () => fileId,
        ); // update boxData
      }
    } // update boxData
    // Hive learning: need to put again for data persistence on app restart
    await box.put(1, boxData); // put boxData
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

Future<void> setTopicImagePathsMap() async {
  await openTopicImageInfoBox().then((Box topicImageInfoBox) async {
    topicImagePathsMap =
        topicImageInfoBox.containsKey(0) ? await topicImageInfoBox.get(0) : {};
  });
}

Future<Box> Function() openTopicImageInfoBox = () async {
  return await Hive.openBox("topicImageInfo");
};
