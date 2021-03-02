import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

Future<dynamic> fetchProvinces() async {
  List<String> _provinces = [];

  try {
    var _provincesUrl =
        "${FlutterConfig.get('BASE_URL')}:${FlutterConfig.get('PORT')}/discover-canada/api/provinces";
    final _response =
        await http.get(_provincesUrl).timeout(Duration(seconds: 5));
    if (_response.statusCode == 200) {
      final _extractedData = jsonDecode(_response.body);
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
