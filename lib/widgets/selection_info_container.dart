import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models and providers/selected_topic_provider.dart';
import '../models and providers/selected_province_provider.dart';

class SelectionInfoContainer extends StatelessWidget {
  const SelectionInfoContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<SelectedTopic>(
            builder: (ctx, selectedTopic, _) {
              return Text(
                "${selectedTopic.title}",
                softWrap: true,
                textScaleFactor: 1.5,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          Row(
            children: <Widget>[
              const Text(
                "Province: ",
                softWrap: true,
                textScaleFactor: 1.2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer<SelectedProvince>(
                builder: (ctx, selectedProvince, _) {
                  return Text(
                    "${selectedProvince.name}",
                    softWrap: true,
                    textScaleFactor: 1.2,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
