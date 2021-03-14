import 'package:flutter/material.dart';

class SelectedProvince with ChangeNotifier {
  String _provinceName;

  String get name => _provinceName;

  void selectProvince(String provinceName) {
    _provinceName = provinceName;
    notifyListeners();
  }
}
