import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import '../helpers/base.dart';
import '../models and providers/internet_connectivity_provider.dart';

class NoInternetMessage extends StatefulWidget {
  const NoInternetMessage({
    Key key,
  }) : super(key: key);

  @override
  _NoInternetMessageState createState() => _NoInternetMessageState();
}

class _NoInternetMessageState extends State<NoInternetMessage> {
  var _subscription;

  @override
  void didChangeDependencies() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) async {
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print("Internet On");
          } else {
            print("Internet Off");
          }
        } catch (_) {
          print("Internet Off");
        }
      } else {
        print("Internet Off");
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _NoInternetMessageState");

    return Container(
      child: Text(
        "has Internet:",
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize1 * 0.75,
        ),
      ),
      color: Colors.red,
      width: double.maxFinite,
      padding: EdgeInsets.all(5),
    );
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
