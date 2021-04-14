import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
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

saveTopicImages(dynamic data) async {
  String filePath = _appDocDir.path + "/" + "images" + "/";
  data.forEach((obj) async {
    try {
      String imageUrl = FlutterConfig.get('BASE_URL') + obj["image_url"];
      final Response response = await Dio()
          .get(
            imageUrl,
            options: Options(responseType: ResponseType.bytes),
          )
          .timeout(Duration(seconds: timeOut));
      RegExp imageNameRegExp = RegExp(r"\w*\d*\.\w*");
      String imageName = imageNameRegExp.stringMatch(imageUrl);
      File imageFile = File(filePath + imageName);
      await imageFile.writeAsBytes(response.data);
    } catch (e) {
      print("manage_files2 $e");
    }
  });
}
