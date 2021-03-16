import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return LoaderProvinceSelectionDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build TopicCard");
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
              '${FlutterConfig.get('BASE_URL')}/${topic.imageUrl}',
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
                '${topic.title}',
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
                onTap: () => _tapTopic(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
