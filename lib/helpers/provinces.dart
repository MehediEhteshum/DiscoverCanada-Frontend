import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';

import './base.dart';

Future<Box> Function() _openProvincesBox = () async {
  return await Hive.openBox("provinces");
};

Future<dynamic> fetchProvinces(bool isOnline) async {
  Future<dynamic> error;

  await _openProvincesBox().then((Box provincesBox) async {
    if (isOnline) {
      // if online, fetch from internet
      try {
        String provincesUrl =
            "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/provinces";
        final Response response =
            await Dio().get(provincesUrl).timeout(Duration(seconds: timeOut));
        if (response.statusCode == successCode) {
          final dynamic extractedData = response.data;
          if (extractedData["data"] != null) {
            await _storeProvincesData(provincesBox, extractedData["data"]);
            final List<String> _provinces =
                _createProvincesList(extractedData["data"]);
            provinces = [..._provinces]; // assigning to global variable
            throw ("NoError");
          } else {
            throw ("EmptyData");
          }
        } else {
          throw ("Error loading data: ${response.statusCode}");
        }
      } catch (e) {
        print("provinces1 $e");
        error = Future.error(e.toString());
      }
    } else {
      // if offline, fetch from device
      dynamic provincesData =
          provincesBox.containsKey(0) ? provincesBox.values.elementAt(0) : null;
      if (provincesData != null) {
        final List<String> _provinces = _createProvincesList(provincesData);
        provinces = [..._provinces]; // assigning to global variable
        throw ("NoError");
      } else {
        throw ("EmptyData");
      }
    }
  }).catchError((e) {
    print("provinces2 $e");
    error = Future.error(e.toString());
  });

  return error;
}

Future<void> _storeProvincesData(Box provincesBox, dynamic data) async {
  // learning: for storing data, box method e.g. 'put' needs to be used for data persistence on app restart. method on toMap() doesn't keep data on app restart.
  await provincesBox.put(0, data); // storing at default key
}

List<String> _createProvincesList(dynamic data) {
  final List<String> _provinces = [];
  data.forEach((provinceObj) => {
        _provinces.add(provinceObj["name"]),
      });
  return _provinces;
}
