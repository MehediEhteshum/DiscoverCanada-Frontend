import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../helpers/base.dart';
import '../models and providers/chapter.dart';

class ChapterCard extends StatelessWidget {
  const ChapterCard({
    Key key,
    @required this.chapter,
  }) : super(key: key);

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shadowColor: Colors.grey,
      elevation: cardElevation, // fixed dim
      margin: cardMargin, // fixed dim
      shape: RoundedRectangleBorder(
        borderRadius: cardBorderRadius, // fixed dim
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: AutoSizeText(
          "${chapter.title}",
          softWrap: true,
          textAlign: TextAlign.center,
          maxLines: 4,
          maxFontSize: fontSize1,
          minFontSize: fontSize1 * 0.75,
          style: const TextStyle(
            fontSize: fontSize1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
