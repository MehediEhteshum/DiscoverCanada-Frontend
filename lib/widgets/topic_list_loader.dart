import 'package:flutter/material.dart';

import './topic_card.dart';
import '../helpers/topics.dart';
import '../models/topic.dart';

class TopicListLoader extends StatefulWidget {
  const TopicListLoader({Key key}) : super(key: key);

  @override
  _TopicListLoaderState createState() => _TopicListLoaderState();
}

class _TopicListLoaderState extends State<TopicListLoader> {
  Future<List<Topic>> futureTopics;

  @override
  void initState() {
    super.initState();
    futureTopics = fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Topic>>(
        future: futureTopics,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var topics = snapshot.data;
            return topics.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    itemCount: topics.length,
                    itemBuilder: (BuildContext _, int index) {
                      return TopicCard(
                        topics: topics,
                        index: index,
                      );
                    },
                  )
                : Text('Something went wrong');
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
