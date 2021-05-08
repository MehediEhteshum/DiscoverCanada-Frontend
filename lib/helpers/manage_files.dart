import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
