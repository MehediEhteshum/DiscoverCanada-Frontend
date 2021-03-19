import 'package:flutter/material.dart';

import './retry.dart';
import 'topic_card.dart';
import '../helpers/topics.dart';

class LoaderTopicList extends StatefulWidget {
  const LoaderTopicList({Key key}) : super(key: key);

  @override
  _LoaderTopicListState createState() => _LoaderTopicListState();
}

class _LoaderTopicListState extends State<LoaderTopicList> {
  Future<dynamic> _fetchTopics;
  static bool _isLoading = true;

  @override
  void initState() {
    _fetchTopics = fetchTopics().then((data) {
      _isLoading = false;
      return data; // return data to capture in the snapshot
    }).catchError((_) {
      // retruns null error to snapshot.error
      _isLoading = false;
    });
    super.initState();
  }

  Future<void> _refreshWidget() async {
    _isLoading = true;
    setState(() {
      _fetchTopics = fetchTopics().then((data) {
        _isLoading = false;
        return data; // return data to capture in the snapshot
      }).catchError((_) {
        // retruns null error to snapshot.error
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _LoaderTopicListState");
    return Center(
      child: FutureBuilder<dynamic>(
        future: _fetchTopics,
        builder: (_, snapshot) {
          if (_isLoading) {
            return const CircularProgressIndicator();
          } else {
            var _topics = snapshot.data;
            if (_topics != null) {
              // not null when snapshot.hasError != true
              return _topics.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10), // fixed dim
                      itemCount: _topics.length,
                      itemBuilder: (BuildContext _, int index) {
                        return TopicCard(
                          topic: _topics[index],
                        );
                      },
                    )
                  : Retry(refreshWidget: _refreshWidget);
            } else {
              // when snapshot.hasError == true
              return Retry(refreshWidget: _refreshWidget);
            }
          }
        },
      ),
    );
  }
}
