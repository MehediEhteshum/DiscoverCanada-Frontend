import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../models and providers/selected_topic_provider.dart';
import '../models and providers/selected_province_provider.dart';

class SelectionInfo extends StatelessWidget {
  const SelectionInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build SelectionInfo");
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final double _appBarHeight = kToolbarHeight; // AppBar default height

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
          padding: EdgeInsets.fromLTRB(20, _statusBarHeight + _appBarHeight, 20,
              _statusBarHeight), // variable
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: unitWidthFactor *
                          1.75, // proportional to screen width
                    ),
                  );
                },
              ),
              Consumer<SelectedProvince>(
                builder: (ctx, selectedProvince, _) {
                  return Text(
                    "${selectedProvince.name}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          unitWidthFactor * 1.3, // proportional to screen width
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
