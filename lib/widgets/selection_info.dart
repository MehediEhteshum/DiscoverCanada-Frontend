import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import '../models and providers/selected_topic_provider.dart';
import '../models and providers/selected_province_provider.dart';

class SelectionInfo extends StatelessWidget {
  const SelectionInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Consumer<SelectedTopic>(
          builder: (ctx, selectedTopic, _) {
            return Image.network(
              '${FlutterConfig.get('BASE_URL')}/${selectedTopic.imageUrl}',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 20.0 + 56.0, bottom: 15),
          color: Colors.black54,
          width: double.maxFinite,
          child: Column(
            children: [
              const Spacer(),
              Consumer<SelectedTopic>(
                builder: (ctx, selectedTopic, _) {
                  return Text(
                    "${selectedTopic.title}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  );
                },
              ),
              Consumer<SelectedProvince>(
                builder: (ctx, selectedProvince, _) {
                  return Text(
                    "${selectedProvince.name}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
