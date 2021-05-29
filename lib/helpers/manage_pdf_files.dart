import 'package:hive/hive.dart';

import 'base.dart';
import './manage_files.dart' as mf;

Future<void> saveChapterPdfPath(Box box, String filePath, int chapterId) async {
  Map boxData;
  Map filePathsMap;
  // filePaths are saved at key 0
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, {
      selectedTopic.id: {
        selectedProvince: {chapterId: filePath}
      }
    });
  } else {
    // 0 key exists
    boxData = await box.get(0); // get boxData
    if (!boxData.containsKey(selectedTopic.id)) {
      // topic key not exists. so newFilePath
      await boxData.putIfAbsent(
        selectedTopic.id,
        () => {
          selectedProvince: {chapterId: filePath}
        },
      ); // update boxData
    } else {
      // topic key exists
      if (!boxData[selectedTopic.id].containsKey(selectedProvince)) {
        // province key not exists. so newFilePath
        await boxData[selectedTopic.id].putIfAbsent(
          selectedProvince,
          () => {chapterId: filePath},
        ); // update boxData
      } else {
        // province key exists. store newFilePath or replace oldFilePath
        filePathsMap = boxData[selectedTopic.id][selectedProvince];
        if (!filePathsMap.containsKey(chapterId)) {
          // empty or no such chapter key yet. so newFilePath
          filePathsMap[chapterId] = filePath; // update filePathsMap
        } else {
          // not empty and chapter key exists.
          // make sure path is unique, then replace oldFilePath
          filePath = await mf.generateUniqueFilePath(
              filePathsMap, chapterId, filePath);
          filePathsMap[chapterId] = filePath; // update filePathsMap
        }
        await boxData[selectedTopic.id].update(
          selectedProvince,
          (curr) => filePathsMap,
          ifAbsent: () => filePathsMap,
        ); // update boxData
      }
    } // update boxData
    // Hive learning: need to put again for data persistence on app restart
    await box.put(0, boxData); // put boxData
  }
}

Future<bool> isNewChapterPdf(Box box, String fileId, int chapterId) async {
  Map boxData;
  Map fileIdsMap;
  bool isNewFile;
  // etags are saved at key 1
  if (!box.containsKey(1)) {
    // 1 key not exists. so newFile
    isNewFile = true;
    await box.put(1, {
      selectedTopic.id: {
        selectedProvince: {chapterId: fileId}
      }
    });
  } else {
    // 1 key exists
    boxData = await box.get(1); // get boxData
    if (!boxData.containsKey(selectedTopic.id)) {
      // topic key not exists. so newFile
      isNewFile = true;
      await boxData.putIfAbsent(
        selectedTopic.id,
        () => {
          selectedProvince: {chapterId: fileId}
        },
      );
    } else {
      // topic key exists
      if (!boxData[selectedTopic.id].containsKey(selectedProvince)) {
        // province key not exists. so newFile
        isNewFile = true;
        await boxData[selectedTopic.id].putIfAbsent(
          selectedProvince,
          () => {chapterId: fileId},
        ); // update boxData
      } else {
        // province key exists. check if newFile
        fileIdsMap = boxData[selectedTopic.id][selectedProvince];
        if (!fileIdsMap.containsKey(chapterId)) {
          // empty or no such chapter key yet. so newFile.
          isNewFile = true;
          fileIdsMap[chapterId] = fileId; // update fileIdsMap
        } else {
          // not empty and chapter key exists. check if newFile.
          isNewFile = (fileId != fileIdsMap[chapterId]);
          if (isNewFile) {
            // replace old fileId
            fileIdsMap[chapterId] = fileId; // update fileIdsMap
          }
        }
        await boxData[selectedTopic.id].update(
          selectedProvince,
          (currData) => fileIdsMap,
          ifAbsent: () => fileIdsMap,
        ); // update boxData
      }
    } // update boxData
    // Hive learning: need to put again for data persistence on app restart
    await box.put(1, boxData); // put boxData
  }
  return isNewFile;
}

Future<void> setChapterPdfPathsMap() async {
  await openChapterPdfInfoBox().then((Box chapterPdfInfoBox) async {
    chapterPdfPathsMap = chapterPdfInfoBox.containsKey(0)
        ? await chapterPdfInfoBox.get(0)[selectedTopic.id][selectedProvince]
        : {};
  });
}

Future<Box> Function() openChapterPdfInfoBox = () async {
  return await Hive.openBox("chapterPdfInfo");
};
