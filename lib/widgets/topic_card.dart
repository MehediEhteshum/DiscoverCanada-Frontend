import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../models and providers/selected_topic_provider.dart';
import './loader_province_selection_dialog.dart';
import '../models and providers/topic.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
    Key key,
    @required this.topic,
  }) : super(key: key);

  final Topic topic;

  void _tapTopic(BuildContext context) {
    Provider.of<SelectedTopic>(context, listen: false).selectTopic(topic);
    if (topic.provinceDependent) {
      showDialog(
        context: context,
        builder: (context) {
          return LoaderProvinceSelectionDialog();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build TopicCard");
    double cardHeight = screenWidth * 0.5; // proportional to screen width

    return Card(
      shadowColor: Colors.grey,
      elevation: 8, // fixed dim
      margin: const EdgeInsets.all(10), // fixed dim
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // fixed dim
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15), // fixed dim
            child: Image.network(
              '${FlutterConfig.get('BASE_URL')}/${topic.imageUrl}',
              height:
                  cardHeight, // proportional to screen width, dictating card height
              width: double.infinity,
              fit: BoxFit.cover,
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
