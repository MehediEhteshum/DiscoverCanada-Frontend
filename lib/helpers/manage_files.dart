import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import './base.dart';

Directory _appDocDir;

Future<void> createDirPath(String dirPathToBeCreated) async {
  try {
    _appDocDir = await getApplicationDocumentsDirectory();
    Directory finalDir = Directory(_appDocDir.path + "/" + dirPathToBeCreated);
    bool dirExists = await finalDir.exists();
    if (!dirExists) {
      await finalDir.create();
    }
  } catch (e) {
    print("manage_files1 $e");
  }
}

Future<void> saveTopicImages(dynamic data) async {
  String imagesFolderPath = _appDocDir.path + "/" + "images" + "/";
  data.forEach((obj) async {
    try {
      String imageUrl = FlutterConfig.get('BASE_URL') + obj["image_url"];
      bool isNewTopicImage = await _isNewTopicImage(imageUrl, obj["id"]);
      if (isNewTopicImage) {
        // new image, so store in device
        RegExp imageNameRegExp = RegExp(r"\w*\d*\.\w*");
        String imageName = imageNameRegExp.stringMatch(obj["image_url"]);
        String imageFilePath = imagesFolderPath + imageName;
        File imageFile = File(imageFilePath);
        await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
          List<String> _topicImagePathsList =
              topicImageInfoBox.containsKey(0) ? topicImageInfoBox.get(0) : [];
          if (_topicImagePathsList == null ||
              !_topicImagePathsList.asMap().containsKey(obj["id"] - 1)) {
            // no pathsList or no current key yet
            _topicImagePathsList.add(imageFilePath);
          } else {
            // replace old path
            _topicImagePathsList
                .replaceRange(obj["id"] - 1, obj["id"], [imageFilePath]);
          }
          await topicImageInfoBox.put(0, _topicImagePathsList);
          // Hive Learning: avoid generate items to be saved after await i.e. make sure you have data ready before calling Hive method 'put'
          final Response response = await Dio()
              .get(
                imageUrl,
                options: Options(responseType: ResponseType.bytes),
              )
              .timeout(Duration(seconds: timeOut));
          await imageFile.writeAsBytes(response.data);
        });
      }
    } catch (e) {
      print("manage_files2 $e");
    }
  });
}

Future<bool> _isNewTopicImage(String path, int objId) async {
  try {
    final Response testResponse = await Dio()
        .head(
          path,
          options: Options(responseType: ResponseType.stream),
        )
        .timeout(Duration(seconds: timeOut));
    String fileId = testResponse.headers.value("etag");
    bool isNewFile =
        await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
      List<String> savedFileIds = topicImageInfoBox.get(1);
      if (savedFileIds != null) {
        if (savedFileIds.asMap().containsKey(objId - 1)) {
          bool isNewFile = (fileId != savedFileIds[objId - 1]);
          if (isNewFile) {
            // replace old fileId
            savedFileIds.replaceRange(objId - 1, objId, [fileId]);
            await topicImageInfoBox.put(1, savedFileIds);
          }
          return (isNewFile);
        } else {
          savedFileIds.add(fileId); // as the key i.e. value doesn't exist yet
          await topicImageInfoBox.put(1, savedFileIds);
          return true;
        }
      } else {
        await topicImageInfoBox
            .put(1, [fileId]); // savedFileIds == null means first time
        return true;
      }
    });
    return isNewFile;
  } catch (e) {
    print("manage_files3 $e");
    return false;
  }
}

Future<void> createTopicImagesPathsList() async {
  await _openTopicImageInfoBox().then((Box topicImageInfoBox) async {
    topicImagePathsList = topicImageInfoBox.get(0);
  });
}

Future<Box> Function() _openTopicImageInfoBox = () async {
  return await Hive.openBox("topicImageInfo");
};
