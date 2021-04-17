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

  void _tapChapter() {
    // selectedTopic = topic;
    // if (selectedTopic.isProvinceDependent) {
    //   // when topic requires province selection
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return LoaderProvinceSelectionDialog();
    //     },
    //   );
    // } else {
    //   // when topic doesn't require province selection
    //   selectedProvince = "All Provinces";
    //   Navigator.of(context).pushNamed(ChaptersOverviewScreen.routeName);
    // }
  }

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
      child: Stack(
        children: <Widget>[
          Container(
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
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _tapChapter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
