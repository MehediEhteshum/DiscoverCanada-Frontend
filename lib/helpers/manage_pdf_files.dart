import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'base.dart';

Future<void> saveChapterPdf(
    Box box, String filePath, int objId, String url, File file) async {
  Map boxData;
  if (!box.containsKey(0)) {
    // 0 key not exists. so newFilePath
    await box.put(0, {
      selectedTopic.id: {
        selectedProvince: [filePath]
      }
    });
  } else {
    // 0 key exists
    boxData = await box.get(0); // get boxData
    if (!box.get(0).containsKey(selectedTopic.id)) {
      // topic key not exists. so newFilePath
      boxData.putIfAbsent(
          selectedTopic.id,
          () => {
                selectedProvince: [filePath]
              }); // update boxData
      // Hive learning: need to put again for data persistence on app restart
      await box.put(0, boxData); // put boxData
    } else {
      // topic key exists
      if (!box.get(0)[selectedTopic.id].containsKey(selectedProvince)) {
        // province key not exists. so newFilePath
        boxData[selectedTopic.id]
            .putIfAbsent(selectedProvince, () => [filePath]); // update boxData
        // Hive learning: need to put again for data persistence on app restart
        await box.put(0, boxData); // put boxData
      } else {
        // province key exists. store newFilePath or replace oldFilePath
        List<String> filePathsList =
            box.get(0)[selectedTopic.id][selectedProvince];
        if (filePathsList.isEmpty ||
            !filePathsList.asMap().containsKey(objId)) {
          // pathsList empty or no such key yet. so newFilePath
          filePathsList.add(filePath);
        } else {
          // pathsList not empty and key exists. replace oldFilePath
          filePathsList.replaceRange(objId, objId + 1, [filePath]);
        }
        boxData = await box.get(0); // get boxData
        await boxData[selectedTopic.id].update(
          selectedProvince,
          (currData) => filePathsList,
          ifAbsent: () => filePathsList,
        ); // update boxData
        // Hive learning: need to put again for data persistence on app restart
        await box.put(0, boxData); // put boxData
      }
    }
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

Future<bool> isNewChapterPdf(Box box, String fileId, int objId) async {
  Map boxData;
  bool isNewFile;
  if (!box.containsKey(1)) {
    // 1 key not exists. so newFile
    isNewFile = true;
    await box.put(1, {
      selectedTopic.id: {
        selectedProvince: [fileId]
      }
    });
  } else {
    // 1 key exists
    boxData = await box.get(1); // get boxData
    if (!box.get(1).containsKey(selectedTopic.id)) {
      // topic key not exists. so newFile
      isNewFile = true;
      boxData.putIfAbsent(
          selectedTopic.id,
          () => {
                selectedProvince: [fileId]
              }); // update boxData
      // Hive learning: need to put again for data persistence on app restart
      await box.put(1, boxData); // put boxData
    } else {
      // topic key exists
      if (!box.get(1)[selectedTopic.id].containsKey(selectedProvince)) {
        // province key not exists. so newFile
        isNewFile = true;
        boxData[selectedTopic.id]
            .putIfAbsent(selectedProvince, () => [fileId]); // update boxData
        // Hive learning: need to put again for data persistence on app restart
        await box.put(1, boxData); // put boxData
      } else {
        // province key exists. check if newFile
        List<String> fileIdsToUpdate =
            box.get(1)[selectedTopic.id][selectedProvince];
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
        boxData = await box.get(1); // get boxData
        await boxData[selectedTopic.id].update(
          selectedProvince,
          (currData) => fileIdsToUpdate,
          ifAbsent: () => [...fileIdsToUpdate],
        ); // update boxData
        // Hive learning: need to put again for data persistence on app restart
        await box.put(1, boxData); // put boxData
      }
    }
  }
  return isNewFile;
}

Future<void> setChapterPdfPathsList() async {
  await openChapterPdfInfoBox().then((Box chapterPdfInfoBox) async {
    chapterPdfPathsList = chapterPdfInfoBox.containsKey(0)
        ? chapterPdfInfoBox.get(0)[selectedTopic.id][selectedProvince]
        : [];
  });
}

Future<Box> Function() openChapterPdfInfoBox = () async {
  return await Hive.openBox("chapterPdfInfo");
};
