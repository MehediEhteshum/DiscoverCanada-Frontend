import 'package:flutter/material.dart';

import '../models/topic.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
    Key key,
    @required this.topics,
    @required this.index,
  }) : super(key: key);

  final List<Topic> topics;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Card(
        color: Colors.lightGreen,
        elevation: 10,
        margin: const EdgeInsets.only(
          left: 10,
          top: 20,
          right: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width / 30),
        ),
        child: Stack(children: <Widget>[
          Positioned(
            bottom: MediaQuery.of(context).size.width / 30,
            right: MediaQuery.of(context).size.width / 30,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.75,
              color: Colors.black38,
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              child: Text(
                '${topics[index].title}',
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 30,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
