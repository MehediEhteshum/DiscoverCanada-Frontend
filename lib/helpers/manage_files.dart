import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import './base.dart';

Directory appDocDir;

Future<void> createDirPath(String dirPathToBeCreated) async {
  try {
    if (appDocDir == null) {
      appDocDir = await getApplicationDocumentsDirectory();
    }
    Directory finalDir = Directory(appDocDir.path + "/" + dirPathToBeCreated);
    bool dirExists = await finalDir.exists();
    if (!dirExists) {
      await finalDir.create();
    }
  } catch (e) {
    print("manage_files1 $e");
  }
}

Future<bool> isNewFile(
    String url, int objId, Function openBox, String fileType) async {
  try {
    final Response testResponse = await Dio()
        .head(
          url,
          options: Options(responseType: ResponseType.stream),
        )
        .timeout(Duration(seconds: timeOut));
    String fileId = testResponse.headers.value("etag");
    bool _isNewFile = await openBox().then((Box box) async {
      bool isNew;
      if (fileType == "chapterPdf") {
        isNew = await isNewChapterPdf(box, fileId, objId);
      } else if (fileType == "topicImage") {
        isNew = await isNewTopicImage(box, fileId, objId);
      }
      return isNew;
    });
    return _isNewFile;
  } catch (e) {
    print("manage_pdf_files2 $e");
    return false;
  }
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
