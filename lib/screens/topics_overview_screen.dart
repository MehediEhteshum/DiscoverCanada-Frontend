import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../helpers/topics.dart';
import '../widgets/topic_card.dart';
import '../widgets/no_internet_message.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../widgets/retry.dart';

class TopicsOverviewScreen extends StatefulWidget {
  @override
  _TopicsOverviewScreenState createState() => _TopicsOverviewScreenState();
}

class _TopicsOverviewScreenState extends State<TopicsOverviewScreen> {
  static bool _isOnline = false;
  static bool _isLoading = true;
  static String _error;

  @override
  void didChangeDependencies() {
    setState(() {
      _isOnline = Provider.of<InternetConnectivity>(context).isOnline;
      _refreshWidget(); // as soon as online/offline, it refreshes widget
    });
    super.didChangeDependencies();
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    await fetchTopics(_isOnline).catchError((error) {
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
            _isOnline ? 1 : 0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : (_error == "NoError" && topics.length > 0)
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
}
