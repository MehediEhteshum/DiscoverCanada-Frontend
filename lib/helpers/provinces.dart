import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';

import './base.dart';

Future<dynamic> fetchProvinces() async {
  List<String> _provinces = [];

  try {
    var _provincesUrl =
        "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/provinces";
    final Response _response =
        await Dio().get(_provincesUrl).timeout(Duration(seconds: timeOut));
    if (_response.statusCode == successCode) {
      final _extractedData = _response.data;
      if (_extractedData["data"] != null) {
        _extractedData["data"].forEach((_provinceObj) => {
              _provinces.add(
                _provinceObj["name"],
              ),
            });
      }
    } else {
      throw ("Error loading data: ${_response.statusCode}");
    }
  } catch (e) {
    return Future.error(e.toString());
  }

  return _provinces;
}
