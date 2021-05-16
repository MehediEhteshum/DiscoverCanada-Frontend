import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import './base.dart';
import './manage_image_files.dart' as mif;
import './manage_pdf_files.dart' as mpf;

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

Future<void> saveFiles(dynamic data, String folderName, String fileType) async {
  String folderPath = appDocDir.path + "/" + "$folderName" + "/";
  data.forEach((obj) async {
    String url;
    int objId;
    Function openBox;
    try {
      if (fileType == fileTypes[0]) {
        // topicImage
        url = FlutterConfig.get('BASE_URL') + obj["image_url"];
        objId = obj["id"] - 1; // topicIndex = topicId - 1
        openBox = mif.openTopicImageInfoBox;
      } else if (fileType == fileTypes[1]) {
        // chapterPdf
        url = obj["pdf_url"];
        objId = data.indexOf(obj); // index of each chapter
        openBox = mpf.openChapterPdfInfoBox;
      }
      bool _isNewFile = await isNewFile(url, objId, openBox, fileType);
      if (_isNewFile) {
        // new file, so store in device
        String fileName;
        if (fileType == fileTypes[0]) {
          // topicImage
          RegExp fileNameRegExp = RegExp(r"\w*\d*\.\w*");
          fileName = fileNameRegExp.stringMatch(obj["image_url"]);
        } else if (fileType == fileTypes[1]) {
          // chapterPdf
          fileName = obj["title"] + ".pdf";
        }
        String filePath = folderPath + fileName;
        File file = File(filePath);
        await openBox().then((Box box) async {
          if (fileType == fileTypes[0]) {
            // topicImage
            await mif.saveTopicImage(box, filePath, objId, url, file);
          } else if (fileType == fileTypes[1]) {
            // chapterPdf
            await mpf.saveChapterPdf(box, filePath, objId, url, file);
          }
        });
      }
    } catch (e) {
      print("manage_files2 $e");
    }
  });
}

Future<bool> isNewFile(
    String url, int objId, Function openBox, String fileType) async {
  try {
    final Response testResponse = await Dio()
        .head(
          url,
          options: Options(responseType: ResponseType.stream),
        );
    String fileId = testResponse.headers.value("etag");
    bool _isNewFile = await openBox().then((Box box) async {
      bool isNew;
      if (fileType == fileTypes[0]) {
        // topicImage
        isNew = await mif.isNewTopicImage(box, fileId, objId);
      } else if (fileType == fileTypes[1]) {
        // chapterPdf
        isNew = await mpf.isNewChapterPdf(box, fileId, objId);
      }
      return isNew;
    });
    return _isNewFile;
  } catch (e) {
    print("manage_files3 $e");
    return false;
  }
}
