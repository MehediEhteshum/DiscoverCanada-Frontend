import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import '../helpers/base.dart';

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
        Image.network(
          '${FlutterConfig.get('BASE_URL')}/${selectedTopic.imageUrl}',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, _statusBarHeight + _appBarHeight, 20,
              _statusBarHeight), // variable
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
