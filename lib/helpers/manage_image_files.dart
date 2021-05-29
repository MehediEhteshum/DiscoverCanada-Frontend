import 'package:hive/hive.dart';

import './base.dart';
import './manage_files.dart' as mf;

Future<void> saveTopicImagePath(Box box, String filePath, int topicId) async {
  Map filePathsMap;
  // filePaths are saved at key 0
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, {topicId: filePath});
  } else {
    // 0 key exists. store newFilePath or replace oldFilePath
    filePathsMap = await box.get(0);
    if (!filePathsMap.containsKey(topicId)) {
      // topic key not exists. so newFilePath
      filePathsMap[topicId] = filePath; // update filePathsMap
    } else {
      // topic key exists
      // make sure path is unique, then replace oldFilePath
      filePath =
          await mf.generateUniqueFilePath(filePathsMap, topicId, filePath);
      filePathsMap[topicId] = filePath; // update filePathsMap
    } // update filePathsMap
    // Hive learning: need to put again for data persistence on app restart
    await box.put(0, filePathsMap); // put filePathsMap
  }
}

Future<bool> isNewTopicImage(Box box, String fileId, int topicId) async {
  Map fileIdsMap;
  bool isNewFile;
  // etags are saved at key 1
  if (!box.containsKey(1)) {
    // 1 key not exists. so newFile
    isNewFile = true;
    await box.put(1, {topicId: fileId});
  } else {
    // 1 key exists. check if newFile
    fileIdsMap = await box.get(1);
    if (!fileIdsMap.containsKey(topicId)) {
      // topic key not exists. so newFile
      isNewFile = true;
      fileIdsMap[topicId] = fileId; // update fileIdsMap
    } else {
      // topic key exists. check if newFile.
      isNewFile = (fileId != fileIdsMap[topicId]);
      if (isNewFile) {
        // replace old fileId
        fileIdsMap[topicId] = fileId; // update fileIdsMap
      }
    } // update fileIdsMap
    // Hive learning: need to put again for data persistence on app restart
    await box.put(1, fileIdsMap); // put fileIdsMap
  }
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
