import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetConnectivity with ChangeNotifier {
  bool _hasInternet;
  // String _internetType;

  bool get isOnline => _hasInternet;

  void checkAndSetStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      // _internetType = null;
      _hasInternet = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // _internetType = "wifi";
    } else if (connectivityResult == ConnectivityResult.mobile) {
      // _internetType = "mobile";
    }
    notifyListeners();
  }
}
