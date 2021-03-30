import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetConnectivity with ChangeNotifier {
  bool _hasInternet = true;
  // String _internetType;

  bool get isOnline => _hasInternet;

  void checkAndSetStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _hasInternet = true;
        } else {
          _hasInternet = false;
        }
      } catch (_) {
        _hasInternet = false;
      }
    } else {
      _hasInternet = false;
    }
    notifyListeners();
  }
}
