import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/loader_topic_list.dart';
import '../widgets/no_internet_message.dart';
import '../models and providers/internet_connectivity_provider.dart';

class TopicsOverviewScreen extends StatefulWidget {
  @override
  _TopicsOverviewScreenState createState() => _TopicsOverviewScreenState();
}

class _TopicsOverviewScreenState extends State<TopicsOverviewScreen> {
  bool _isOnline = true;

  @override
  void didChangeDependencies() {
    setState(() {
      _isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build TopicsOverviewScreen");

    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discover Canada",
          softWrap: true,
        ),
        bottom: PreferredSize(
          child: NoInternetMessage(),
          preferredSize: Size.lerp(
            Size(double.maxFinite, 25), // offline
            const Size(0, 0), // online
            _isOnline ? 1 : 0,
          ),
        ),
      ),
      body: const LoaderTopicList(),
    );
  }
}
