import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/base.dart';
import '../models and providers/topic.dart';

class TopicImage extends StatelessWidget {
  const TopicImage({
    Key key,
    @required this.topic,
    this.imageHeight = double.infinity,
  }) : super(key: key);

  final Topic topic;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build LoadTopicCardImage");

    return isOnline == 1
        ? FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: '${FlutterConfig.get('BASE_URL')}/${topic.imageUrl}',
            height:
                imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : topicImagePathsList.asMap().containsKey(topic.id - 1)
            ? FadeInImage(
                // asset image when offline
                placeholder: MemoryImage(kTransparentImage),
                image: FileImage(File(topicImagePathsList[topic.id - 1])),
                height:
                    imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : FadeInImage(
                // asset image when offline
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(noInternetImage),
                height:
                    imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              );
  }
}
