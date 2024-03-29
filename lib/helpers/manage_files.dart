import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import './base.dart';
import './manage_image_files.dart' as mif;
import './manage_pdf_files.dart' as mpf;
import '../models and providers/topic.dart';

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

Future<void> saveFilePaths(
    dynamic data, String folderName, String fileType) async {
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
      // make sure pdf_url != null
      bool _isNewFile = (url != null)
          ? await isNewFile(url, objId, openBox, fileType)
          : false;
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
        String filePath =
            folderPath + fileName; // also check 'getFilePath' function below
        await openBox().then((Box box) async {
          if (fileType == fileTypes[0]) {
            // topicImage
            await mif.saveTopicImagePath(box, filePath, objId);
          } else if (fileType == fileTypes[1] && url != null) {
            // chapterPdf. make sure pdf_url != null
            await mpf.saveChapterPdfPath(box, filePath, objId);
          }
        });
      }
    } catch (e) {
      print("manage_files2 $fileType $e");
    }
  });
}

Future<bool> isNewFile(
    String url, int objId, Function openBox, String fileType) async {
  try {
    final Dio dio = Dio();
    final Response testResponse = await dio
        .request(url)
        .timeout(Duration(seconds: timeOut))
        .catchError((e) {
      print("manage_files0 $fileType $e");
    });
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
    print("manage_files3 $fileType $e");
    return false;
  }
}

String getFilePath(String fileType, [Topic topic]) {
  int objId = (fileType == fileTypes[0]) // topicImage
      ? topic.id - 1 // topic index = topicId - 1
      : (fileType == fileTypes[1]) // chapterPdf
          ? selectedChapter.id
          : null;
  String url = (fileType == fileTypes[0])
      ? topic.imageUrl
      : (fileType == fileTypes[1])
          ? selectedChapter.pdfUrl
          : null;
  bool pathExists;
  String filePath;
  if (fileType == fileTypes[0]) {
    pathExists = topicImagePathsMap.isNotEmpty
        // avoiding Error of calling '.length' on []
        ? topicImagePathsMap.containsKey(objId)
        : false;
  } else if (fileType == fileTypes[1]) {
    pathExists = (chapterPdfPathsMap != null)
        // avoiding nullError
        ? chapterPdfPathsMap.containsKey(objId)
        : false;
  }
  if (!pathExists) {
    // topicImagePathsList or chapterPdfPathsList is empty or not ready at this point. hence, again generate filePath manually
    String folderPath = (fileType == fileTypes[0])
        ? appDocDir.path + "/" + "images" + "/"
        : (fileType == fileTypes[1])
            ? appDocDir.path + "/" + "pdfs" + "/"
            : null;
    RegExp fileNameRegExp = RegExp(r"\w*\d*\.\w*");
    String fileName = (fileType == fileTypes[0])
        ? fileNameRegExp.stringMatch(url)
        : (fileType == fileTypes[1])
            ? selectedChapter.title + ".pdf"
            : null;
    filePath = folderPath + fileName;
  } else {
    // topicImagePathsList or chapterPdfPathsList is ready or contains path
    filePath = (fileType == fileTypes[0])
        ? topicImagePathsMap[objId]
        : (fileType == fileTypes[1])
            ? chapterPdfPathsMap[objId]
            : null;
  }
  return filePath; // also check 'saveFiles' function above
}

Future<Box> Function() openFilePathsToBeDelBox = () async {
  return await Hive.openBox("filePathsToBeDel");
};

Future<void> delFilePathsToBeDel() async {
  await openFilePathsToBeDelBox().then((Box box) async {
    if (box.containsKey(0)) {
      // box not empty
      List<String> filePathsToBeDel = await box.get(0);
      if (filePathsToBeDel.length > 0) {
        // filePathsToBeDel not empty
        filePathsToBeDel.forEach((filePath) async {
          await File(filePath).delete(recursive: true);
        });
      }
      await box.clear();
    }
  });
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
  await openFilePathsToBeDelBox().then((Box box) async {
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
