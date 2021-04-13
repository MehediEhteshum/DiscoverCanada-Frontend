import 'dart:io';

import 'package:path_provider/path_provider.dart';

createDirPath(String dirPathToBeCreated) async {
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory finalDir = Directory(appDocDir.path + "/" + dirPathToBeCreated);
    bool dirExists = await finalDir.exists();
    if (!dirExists) {
      await finalDir.create();
    }
  } catch (e) {
    print(e);
  }
}
