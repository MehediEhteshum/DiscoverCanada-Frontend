import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'base.dart';
import 'manage_files.dart';

Future<void> savePdfs(dynamic data) async {
  String folderPath = appDocDir.path + "/" + "pdfs" + "/";
  data.forEach((obj) async {
    try {
      int objId = data.indexOf(obj); // index of each chapter
      String pdfUrl = obj["pdf_url"] ?? ""; // if null, then ""
      bool isNewFile = await _isNewFile(pdfUrl, objId);
      if (isNewFile) {
        // new file, so store in device
        String fileName = obj["title"] + ".pdf";
        String filePath = folderPath + fileName;
        File file = File(filePath);
        await _openPdfInfoBox().then((Box pdfInfoBox) async {
          Map boxData;
          if (!pdfInfoBox.containsKey(0)) {
            // 0 key not exists. so newFilePath
            await pdfInfoBox.put(0, {
              selectedTopic.id: {
                selectedProvince: [filePath]
              }
            });
          } else {
            // 0 key exists
            boxData = await pdfInfoBox.get(0); // get boxData
            if (!pdfInfoBox.get(0).containsKey(selectedTopic.id)) {
              // topic key not exists. so newFilePath
              boxData.putIfAbsent(
                  selectedTopic.id,
                  () => {
                        selectedProvince: [filePath]
                      }); // update boxData
              // Hive learning: need to put again for data persistence on app restart
              await pdfInfoBox.put(0, boxData); // put boxData
            } else {
              // topic key exists
              if (!pdfInfoBox
                  .get(0)[selectedTopic.id]
                  .containsKey(selectedProvince)) {
                // province key not exists. so newFilePath
                boxData[selectedTopic.id].putIfAbsent(
                    selectedProvince, () => [filePath]); // update boxData
                // Hive learning: need to put again for data persistence on app restart
                await pdfInfoBox.put(0, boxData); // put boxData
              } else {
                // province key exists. store newFilePath or replace oldFilePath
                List<String> filePathsList =
                    pdfInfoBox.get(0)[selectedTopic.id][selectedProvince];
                if (filePathsList.isEmpty ||
                    !filePathsList.asMap().containsKey(objId)) {
                  // pathsList empty or no such key yet. so newFilePath
                  filePathsList.add(filePath);
                } else {
                  // pathsList not empty and key exists. replace oldFilePath
                  filePathsList.replaceRange(objId, objId + 1, [filePath]);
                }
                boxData = await pdfInfoBox.get(0); // get boxData
                await boxData[selectedTopic.id].update(
                  selectedProvince,
                  (currData) => filePathsList,
                  ifAbsent: () => filePathsList,
                ); // update boxData
                // Hive learning: need to put again for data persistence on app restart
                await pdfInfoBox.put(0, boxData); // put boxData
              }
            }
          }
          // Hive Learning: get fileData and write file after Hive method 'put' for saving _filePathsList
          final Response response = await Dio()
              .get(
                pdfUrl,
                options: Options(responseType: ResponseType.bytes),
              )
              .timeout(Duration(seconds: timeOut));
          await file.writeAsBytes(response.data);
        });
      }
    } catch (e) {
      print("manage_pdf_files1 $e");
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
    bool isNewFile = await _openPdfInfoBox().then((Box pdfInfoBox) async {
      Map boxData;
      bool isNewFile;
      if (!pdfInfoBox.containsKey(1)) {
        // 1 key not exists. so newFile
        isNewFile = true;
        await pdfInfoBox.put(1, {
          selectedTopic.id: {
            selectedProvince: [fileId]
          }
        });
      } else {
        // 1 key exists
        boxData = await pdfInfoBox.get(1); // get boxData
        if (!pdfInfoBox.get(1).containsKey(selectedTopic.id)) {
          // topic key not exists. so newFile
          isNewFile = true;
          boxData.putIfAbsent(
              selectedTopic.id,
              () => {
                    selectedProvince: [fileId]
                  }); // update boxData
          // Hive learning: need to put again for data persistence on app restart
          await pdfInfoBox.put(1, boxData); // put boxData
        } else {
          // topic key exists
          if (!pdfInfoBox
              .get(1)[selectedTopic.id]
              .containsKey(selectedProvince)) {
            // province key not exists. so newFile
            isNewFile = true;
            boxData[selectedTopic.id].putIfAbsent(
                selectedProvince, () => [fileId]); // update boxData
            // Hive learning: need to put again for data persistence on app restart
            await pdfInfoBox.put(1, boxData); // put boxData
          } else {
            // province key exists. check if newFile
            List<String> fileIdsToUpdate =
                pdfInfoBox.get(1)[selectedTopic.id][selectedProvince];
            if (fileIdsToUpdate.isEmpty ||
                !fileIdsToUpdate.asMap().containsKey(objId)) {
              // savedFileIds empty or no such key yet. so newFile.
              isNewFile = true;
              fileIdsToUpdate.add(fileId);
            } else {
              // savedFileIds not empty and key exists. check if newFile.
              isNewFile = (fileId != fileIdsToUpdate[objId]);
              if (isNewFile) {
                // replace old fileId
                fileIdsToUpdate.replaceRange(objId, objId + 1, [fileId]);
              }
            }
            boxData = await pdfInfoBox.get(1); // get boxData
            await boxData[selectedTopic.id].update(
              selectedProvince,
              (currData) => fileIdsToUpdate,
              ifAbsent: () => [...fileIdsToUpdate],
            ); // update boxData
            // Hive learning: need to put again for data persistence on app restart
            await pdfInfoBox.put(1, boxData); // put boxData
          }
        }
      }
      return isNewFile;
    });
    return isNewFile;
  } catch (e) {
    print("manage_pdf_files2 $e");
    return false;
  }
}

// Future<void> setTopicImagesPathsList() async {
//   await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
//     topicImagePathsList = topicImageInfoBox.get(0);
//   });
// }

Future<Box> Function() _openPdfInfoBox = () async {
  return await Hive.openBox("pdfInfo");
};
