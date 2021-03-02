import 'package:flutter/material.dart';

import 'topic_card.dart';
import '../helpers/topics.dart';
import '../models/topic.dart';

class LoaderTopicList extends StatefulWidget {
  const LoaderTopicList({Key key}) : super(key: key);

  @override
  _LoaderTopicListState createState() => _LoaderTopicListState();
}

class _LoaderTopicListState extends State<LoaderTopicList> {
  Future<List<Topic>> _fetchTopics;

  @override
  void initState() {
    super.initState();
    _fetchTopics = fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Topic>>(
        future: _fetchTopics,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var _topics = snapshot.data;
            return _topics.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    itemCount: _topics.length,
                    itemBuilder: (BuildContext _, int index) {
                      return TopicCard(
                        topics: _topics,
                        index: index,
                      );
                    },
                  )
                : Text(
                    'Something went wrong! :(',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
