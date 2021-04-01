import 'package:flutter/material.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../helpers/specific_chapters.dart';
import '../widgets/retry.dart';
import '../widgets/chapter_card.dart';

class ChaptersOverviewScreen extends StatefulWidget {
  static const routeName = "/chapters";

  @override
  _ChaptersOverviewScreenState createState() => _ChaptersOverviewScreenState();
}

class _ChaptersOverviewScreenState extends State<ChaptersOverviewScreen> {
  static bool _isLoading = true;
  static bool _isInit = true;
  static String _error;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // runs once at init
      _refreshWidget();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    await fetchAndSetSpecificChapters(selectedTopic.id, selectedProvince)
        .catchError((error) {
      setState(() {
        _error = error;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build ChaptersOverviewScreen");

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : (_error == "NoError")
              ? CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      title: const Text(
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
                    SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      children: specificChapters
                          .map(
                            (chapter) => ChapterCard(
                              chapter: chapter,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              : Retry(refreshWidget: _refreshWidget),
    );
  }

  @override
  void deactivate() {
    _isLoading = true;
    _isInit = true;
    clearChapters();
    super.deactivate();
  }
}
