import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';

import './base.dart';

Future<dynamic> fetchProvinces(bool isOnline) async {
  Future<dynamic> error;
  List<String> _provinces = [];

  if (isOnline) {
    // if online, fetch from internet
    try {
      String provincesUrl =
          "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/provinces";
      final Response response =
          await Dio().get(provincesUrl).timeout(Duration(seconds: timeOut));
      if (response.statusCode == successCode) {
        final extractedData = response.data;
        if (extractedData["data"] != null) {
          extractedData["data"].forEach((_provinceObj) => {
                _provinces.add(
                  _provinceObj["name"],
                ),
              });
          provinces = [..._provinces]; // assigning to global variable
          throw ("NoError");
        }
      } else {
        throw ("Error loading data: ${response.statusCode}");
      }
    } catch (e) {
      error = Future.error(e.toString());
    }
  } else {
    // if offline, fetch from device
    error = Future.error("Offline");
  }

  return error;
}
