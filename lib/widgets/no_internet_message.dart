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
  var _connectivitySubscription;
  bool _isOnline = true;

  @override
  void didChangeDependencies() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) async {
      Provider.of<InternetConnectivity>(context, listen: false)
          .checkAndSetStatus(connectivityResult);
    });
    setState(() {
      _isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _NoInternetMessageState");

    return _isOnline
        ? Container() // online
        : Container(
            child: const Text(
              "No Internet Connection",
              softWrap: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize1 * 0.75,
              ),
            ),
            color: Colors.red,
            width: double.maxFinite,
            height: 25,
            padding: const EdgeInsets.all(5),
          ); // offline
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
