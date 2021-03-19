import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../models and providers/specific_chapters_provider.dart';
import '../models and providers/selected_topic_provider.dart';
import '../models and providers/selected_province_provider.dart';
import '../models and providers/chapter.dart';

class ChaptersOverviewScreen extends StatefulWidget {
  static const routeName = "/chapters";

  @override
  _ChaptersOverviewScreenState createState() => _ChaptersOverviewScreenState();
}

class _ChaptersOverviewScreenState extends State<ChaptersOverviewScreen> {
  static bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final int topicId = Provider.of<SelectedTopic>(context).topicId;
      final String provinceName =
          Provider.of<SelectedProvince>(context).provinceName;
      Provider.of<SpecificChapters>(context)
          .fetchAndSetSpecificChapters(topicId, provinceName);
      print("here $topicId");
    } else {}
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build ChaptersOverviewScreen");
    List<Chapter> chaptersList =
        Provider.of<SpecificChapters>(context).chaptersList;
    print(chaptersList);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "Chapters",
              softWrap: true,
            ),
            floating: true,
            expandedHeight: screenWidth *
                0.4, // proportional to screen width = AppBar kToolbarHeight + Topic title w/ extra 1 line + Province name + Bottom padding statusbarHeight
            flexibleSpace: const FlexibleSpaceBar(
              background: const SelectionInfo(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: const <Widget>[
                const Text(
                  "Chapters Grid jhsdfjhhgs jskdbfjsjbhdf jhbsdjfjhsb kjbsdjkfhkjs jkhskjfkjsh fjksbdfjsjhf jkshdf jhbsdfh hsjhfjs jksbdfjksfbjk sjkdfjkshf kjdbhfjgbdfbjgd sdfbgjdbfjhgbjdsh sjkdbfjsbjfhs jsdbfjsbjdfhbs jsdbfjhsbjfh",
                  softWrap: true,
                  style: TextStyle(fontSize: fontSize1),
                ),
                const SizedBox(height: 2000)
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isInit = true;
    Provider.of<SpecificChapters>(context, listen: false).clearChapters();
    super.dispose();
  }
}
