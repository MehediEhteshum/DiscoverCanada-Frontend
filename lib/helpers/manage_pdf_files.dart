import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import 'base.dart';
import 'manage_files.dart';

Future<void> savePdfs(dynamic data) async {
  String folderPath = appDocDir.path + "/" + "pdfs" + "/";
  data.forEach((obj) async {
    try {
      String pdfUrl = obj["pdf_url"] ?? "";
      bool isNewFile = await _isNewFile(pdfUrl);
      if (isNewFile) {
        // new file, so store in device
        String fileName = obj["title"] + ".pdf";
        String filePath = folderPath + fileName;
        File file = File(filePath);
        await _openPdfInfoBox().then((Box pdfInfoBox) async {
          print("primary ${pdfInfoBox.get(0)}");
          if (!pdfInfoBox.containsKey(0)) {
            // 0 key not exists
            await pdfInfoBox.put(0, {});
          } else {
            // 0 key exists
            if (!pdfInfoBox.get(0).containsKey(selectedTopic.id)) {
              // topic key not exists
              Map currentData = await pdfInfoBox.get(0);
              currentData.putIfAbsent(selectedTopic.id, () => {});
              Map updatedData = await pdfInfoBox.get(0);
              // Hive learning: need to put again for data persistence on app restart
              await pdfInfoBox.put(0, updatedData);
            } else {
              // topic key exists
              if (!pdfInfoBox
                  .get(0)[selectedTopic.id]
                  .containsKey(selectedProvince)) {
                // province key not exists
                Map currentData = await pdfInfoBox.get(0)[selectedTopic.id];
                currentData.putIfAbsent(selectedProvince, () => {});
                Map updatedData = await pdfInfoBox.get(0);
                // Hive learning: need to put again for data persistence on app restart
                await pdfInfoBox.put(0, updatedData);
              }
            }
          }
          print(pdfInfoBox.get(0));
          // var _filePathsList =
          //     pdfInfoBox.get(0)[selectedTopic.id][selectedProvince];
          // int objIndex = data.indexOf(obj);
          // print("$objIndex _filePathsList $_filePathsList");
          // if (_filePathsList.isEmpty ||
          //     !_filePathsList.asMap().containsKey(objIndex)) {
          //   // pathsList empty or no current key yet
          //   _filePathsList.add(filePath);
          // } else {
          //   // replace old path
          //   _filePathsList.replaceRange(objIndex, objIndex + 1, [filePath]);
          // }
          // print(_filePathsList);
          // await pdfInfoBox.put(0, _filePathsList);
          // Hive Learning: avoid generate items to be saved after await i.e. make sure you have data ready before calling Hive method 'put'
          //         final Response response = await Dio()
          //             .get(
          //               imageUrl,
          //               options: Options(responseType: ResponseType.bytes),
          //             )
          //             .timeout(Duration(seconds: timeOut));
          //         await imageFile.writeAsBytes(response.data);
        });
      }
    } catch (e) {
      print("manage_pdf_files1 $e");
    }
  });
}

Future<bool> _isNewFile(String url) async {
  try {
    final Response testResponse = await Dio()
        .head(
          url,
          options: Options(responseType: ResponseType.stream),
        )
        .timeout(Duration(seconds: timeOut));
    String fileId = testResponse.headers.value("etag");
    bool isNewFile = await _openPdfInfoBox().then((Box pdfInfoBox) async {
      List<String> savedFileIds = pdfInfoBox.get(1);
      //     if (savedFileIds != null) {
      //       if (savedFileIds.asMap().containsKey(objId - 1)) {
      //         bool isNewFile = (fileId != savedFileIds[objId - 1]);
      //         if (isNewFile) {
      //           // replace old fileId
      //           savedFileIds.replaceRange(objId - 1, objId, [fileId]);
      //           await topicImageInfoBox.put(1, savedFileIds);
      //         }
      //         return (isNewFile);
      //       } else {
      //         savedFileIds.add(fileId); // as the key i.e. value doesn't exist yet
      //         await topicImageInfoBox.put(1, savedFileIds);
      //         return true;
      //       }
      //     } else {
      //       await topicImageInfoBox
      //           .put(1, [fileId]); // savedFileIds == null means first time
      //       return true;
      //     }
      //   });
      //   return isNewFile;
    });
    return true;
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
