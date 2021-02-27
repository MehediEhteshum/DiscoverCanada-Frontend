import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:frontend/screens/chapter_screen.dart';

import '../models/topic.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
    Key key,
    @required this.topics,
    @required this.index,
  }) : super(key: key);

  final List<Topic> topics;
  final int index;

  void _selectTopic(BuildContext context) {
    print("tapped");
    List<String> testList = ["A", "B", "C"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select a Province"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double unitWidthFactor = MediaQuery.of(context).size.width / 30;
    double unitHeightFactor = MediaQuery.of(context).size.height / 30;
    double cardHeight = unitHeightFactor * 10;

    return Card(
      shadowColor: Colors.grey,
      elevation: 8,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(unitWidthFactor),
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(unitWidthFactor),
            child: Image.network(
              '${FlutterConfig.get('BASE_URL')}/${topics[index].imageUrl}',
              height: cardHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: unitWidthFactor,
            right: unitWidthFactor,
            child: Container(
              width: unitWidthFactor * 17,
              color: Colors.black54,
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
                  fontSize: unitWidthFactor * 1.6,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _selectTopic(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
