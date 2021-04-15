import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetConnectivity with ChangeNotifier {
  int _hasInternet = 2; // basically it is bool(0, 1), 2 during app start-up

  int get isOnline => _hasInternet;

  Future<void> checkAndSetStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _hasInternet = 1;
        } else {
          _hasInternet = 0;
        }
      } catch (e) {
        print("internet_connectivity_provider1 $e");
        _hasInternet = 0;
      }
    } else {
      _hasInternet = 0;
    }
    notifyListeners();
  }
}
