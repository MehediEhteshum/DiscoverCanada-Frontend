import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  void didChangeDependencies() {
    _setStateIfMounted(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    super.didChangeDependencies();
  }

  void _setStateIfMounted(Function f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _NoInternetMessageState");

    return isOnline == 1
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
            height: 25, // fixed
            padding: const EdgeInsets.all(5), // fixed
          ); // offline
  }
}
