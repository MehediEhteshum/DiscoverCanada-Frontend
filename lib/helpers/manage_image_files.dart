import 'package:hive/hive.dart';

import './base.dart';
import './manage_files.dart' as mf;

Future<void> saveTopicImagePath(Box box, String filePath, int objId) async {
  Map filePathsMap;
  // filePaths are saved at key 0
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, {objId: filePath});
  } else {
    // 0 key exists. store newFilePath or replace oldFilePath
    filePathsMap = await box.get(0);
    if (!filePathsMap.containsKey(objId)) {
      // topic key not exists. so newFilePath
      await filePathsMap.putIfAbsent(
        objId,
        () => filePath,
      ); // update boxData
    } else {
      // topic key exists
      // make sure path is unique, then replace oldFilePath
      filePath = await generateUniqueFilePath(filePathsMap, objId, filePath);
      await filePathsMap.update(
        objId,
        (curr) => filePath,
        ifAbsent: () => filePath,
      ); // update boxData
    } // update boxData
    // Hive learning: need to put again for data persistence on app restart
    await box.put(0, filePathsMap); // put boxData
  }
}

Future<String> generateUniqueFilePath(
    Map filePathsMap, int objId, String filePath) async {
  final String oldFilePath = filePathsMap[objId];
  if (filePath == oldFilePath) {
    // path is not unique
    final int lastDotId = oldFilePath.lastIndexOf(".");
    final int verId = oldFilePath.lastIndexOf("-ver");
    if (verId == -1) {
      // "-ver" doesn't exist in oldFilePath.
      filePath = oldFilePath.substring(0, lastDotId) +
          "-ver0" +
          oldFilePath.substring(lastDotId);
    } else {
      // "-ver" exists in oldFilePath.
      filePath =
          oldFilePath.substring(0, verId) + oldFilePath.substring(lastDotId);
    }
  }
  await mf.openFilePathsToBeDelBox().then((Box box) async {
    // save FilePathsToBeDel at 0
    List<String> filePathsToBeDel;
    if (!box.containsKey(0)) {
      // 0 key not exists. fully empty. add filePathToBeDel
      await box.put(0, [oldFilePath]); // update box
    } else {
      // 0 key exists. add filePathToBeDel if not added
      filePathsToBeDel = await box.get(0);
      if (!filePathsToBeDel.contains(oldFilePath)) {
        // oldFilePath wasn't added, so add
        filePathsToBeDel.add(oldFilePath);
        // Hive learning: need to put again for data persistence on app restart
        await box.put(0, filePathsToBeDel); // update box
      }
    }
  });
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
