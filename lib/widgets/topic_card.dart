import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/base.dart';
import '../models and providers/topic.dart';
import '../screens/chapters_overview_screen.dart';
import './topic_image.dart';
import './loader_province_selection_dialog.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
    Key key,
    @required this.topic,
  }) : super(key: key);

  final Topic topic;

  void _tapTopic(BuildContext context) {
    selectedTopic = topic;
    if (selectedTopic.isProvinceDependent) {
      // when topic requires province selection
      showDialog(
        context: context,
        builder: (_) {
          return const LoaderProvinceSelectionDialog();
        },
      );
    } else {
      // when topic doesn't require province selection
      selectedProvince = "All Provinces";
      Navigator.of(context).pushNamed(ChaptersOverviewScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build TopicCard");
    double cardHeight = screenWidth * 0.5; // proportional to screen width

    return Card(
      shadowColor: Colors.grey,
      elevation: cardElevation, // fixed dim
      margin: cardMargin, // fixed dim
      shape: RoundedRectangleBorder(
        borderRadius: cardBorderRadius, // fixed dim
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: cardBorderRadius, // fixed dim
            child: Stack(
              children: <Widget>[
                Shimmer.fromColors(
                  child: Container(
                    color: Colors.white,
                    height:
                        cardHeight, // proportional to screen width, dictating card height
                    width: double.infinity,
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  loop: 10,
                ),
                TopicImage(
                  topic: topic,
                  imageHeight: cardHeight,
                  // proportional to screen width, dictating card height
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15, // fixed dim
            right: 15, // fixed dim
            child: Container(
              width: cardHeight * 1.1, // proportional to card height
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(
                vertical: 5, // fixed dim
                horizontal: 5, // fixed dim
              ),
              child: Text(
                '${topic.title}',
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: cardHeight * 0.10, // proportional to card height
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _tapTopic(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
