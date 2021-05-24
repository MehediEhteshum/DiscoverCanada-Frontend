import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/base.dart';
import './topic_image.dart';

class SelectionInfo extends StatelessWidget {
  const SelectionInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build SelectionInfo");

    return Stack(
      children: <Widget>[
        Shimmer.fromColors(
          child: Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ),
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          loop: 5,
        ),
        TopicImage(
          topic: selectedTopic,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, statusBarHeight + appBarHeight, 20,
              statusBarHeight * 1.25), // variable
          color: Colors.black54,
          width: double.maxFinite,
          child: Column(
            children: [
              const Spacer(),
              Text(
                "${selectedTopic.title}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      unitWidthFactor * 1.75, // proportional to screen width
                ),
              ),
              Text(
                "$selectedProvince",
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      unitWidthFactor * 1.3, // proportional to screen width
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
