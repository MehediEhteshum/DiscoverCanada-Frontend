import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../helpers/topics.dart';
import '../helpers/manage_files.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../widgets/topic_card.dart';
import '../widgets/no_internet_message.dart';
import '../widgets/retry.dart';

class TopicsOverviewScreen extends StatefulWidget {
  @override
  _TopicsOverviewScreenState createState() => _TopicsOverviewScreenState();
}

class _TopicsOverviewScreenState extends State<TopicsOverviewScreen> {
  final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult> _connectivitySubscription;
  static int _isTwice;
  static bool _isLoading;
  static String _error;

  @override
  void initState() {
    _isTwice = 0;
    _isLoading = true;
    createDirPath("images");
    _connectivity.checkConnectivity().then(
      (ConnectivityResult connectivityResult) async {
        await Provider.of<InternetConnectivity>(context, listen: false)
            .updateConnectionStatus(connectivityResult);
      },
    );
    _refreshWidget(); // used for refresh widget and fetch items
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) async {
      await Provider.of<InternetConnectivity>(context, listen: false)
          .updateConnectionStatus(connectivityResult);
    });
    if (mounted) {
      setState(() {
        isOnline = Provider.of<InternetConnectivity>(context).isOnline;
      });
    }
    if (isOnline == 1) {
      _refreshWidget(); // as soon as online, it refreshes widget
    } else if (isOnline == 0 && _isTwice < 2) {
      // runs once at init
      _refreshWidget(); // for offline, allows refresh twice
      _isTwice += 1;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    await fetchTopics(isOnline).catchError((error) {
      setState(() {
        _error = error;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build TopicsOverviewScreen");

    screenWidth = MediaQuery.of(context).size.width;
    statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discover Canada",
          softWrap: true,
        ),
        bottom: PreferredSize(
          child: NoInternetMessage(),
          preferredSize: Size.lerp(
            Size(double.maxFinite, 25), // fixed // offline
            const Size(0, 0), // fixed // online
            isOnline == 0 // offline
                ? 0
                : 1, // isOnline is 2 at app start-up, 1 when online, 0 when offline
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : (_error == "NoError")
              ? Center(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10), // fixed dim
                    itemCount: topics.length,
                    itemBuilder: (BuildContext _, int index) {
                      return TopicCard(
                        topic: topics[index],
                      );
                    },
                  ),
                )
              : Retry(refreshWidget: _refreshWidget),
    );
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
