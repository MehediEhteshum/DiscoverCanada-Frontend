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
  List<String> _topicImagePathsList = [];
  String imagesFolderPath = _appDocDir.path + "/" + "images" + "/";
  data.forEach((obj) async {
    try {
      String imageUrl = FlutterConfig.get('BASE_URL') + obj["image_url"];
      RegExp imageNameRegExp = RegExp(r"\w*\d*\.\w*");
      String imageName = imageNameRegExp.stringMatch(obj["image_url"]);
      String imageFilePath = imagesFolderPath + imageName;
      File imageFile = File(imageFilePath);
      _topicImagePathsList.add(imageFilePath);
      // Hive Learning: avoid generate items to be saved after await i.e. make sure you have data ready before calling Hive method 'put'
      final Response response = await Dio()
          .get(
            imageUrl,
            options: Options(responseType: ResponseType.bytes),
          )
          .timeout(Duration(seconds: timeOut));
      await imageFile.writeAsBytes(response.data);
    } catch (e) {
      print("manage_files2 $e");
    }
  });
  await _openTopicImagePathsBox().then((Box topicImagePathsBox) async {
    await topicImagePathsBox.put(
        0, _topicImagePathsList); // storing at default key
  });
}

Future<void> createTopicImagesPathsList() async {
  await _openTopicImagePathsBox().then((Box topicImagePathsBox) async {
    topicImagePathsList = topicImagePathsBox.get(0);
  });
}

Future<Box> Function() _openTopicImagePathsBox = () async {
  return await Hive.openBox("topicImagePaths");
};
