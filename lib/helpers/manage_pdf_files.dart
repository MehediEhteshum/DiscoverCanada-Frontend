import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'base.dart';
import 'manage_files.dart' as mf;

Future<void> savePdfs(dynamic data) async {
  String folderPath = mf.appDocDir.path + "/" + "pdfs" + "/";
  data.forEach((obj) async {
    try {
      int objId = data.indexOf(obj); // index of each chapter
      String pdfUrl = obj["pdf_url"] ?? ""; // if null, then ""
      bool isNewFile =
          await mf.isNewFile(pdfUrl, objId, _openPdfInfoBox, "chapterPdf");
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

// Future<void> setTopicImagesPathsList() async {
//   await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
//     topicImagePathsList = topicImageInfoBox.get(0);
//   });
// }

Future<Box> Function() _openPdfInfoBox = () async {
  return await Hive.openBox("pdfInfo");
};
