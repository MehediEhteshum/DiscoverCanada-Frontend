import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../helpers/specific_chapters.dart';
import '../widgets/retry.dart';
import '../widgets/chapter_card.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../widgets/no_internet_message.dart';
import '../helpers/manage_files.dart';

class ChaptersOverviewScreen extends StatefulWidget {
  static const routeName = "/chapters";

  @override
  _ChaptersOverviewScreenState createState() => _ChaptersOverviewScreenState();
}

class _ChaptersOverviewScreenState extends State<ChaptersOverviewScreen> {
  static bool _isLoading;
  static String _error;
  static int _isTwice;
  static int _selectedTopicId;

  @override
  void initState() {
    _isLoading = true;
    _isTwice = 0;
    _selectedTopicId = selectedTopic.id;
    if (topicIdsContainPdf.contains(_selectedTopicId)) {
      createDirPath("pdfs");
    }
    _refreshWidget(); // used for refresh widget and fetch items
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    if (isOnline == 1) {
      _refreshWidget(); // as soon as online, it refreshes widget
    } else if (isOnline == 0 && _isTwice < 2) {
      // runs once at init
      _refreshWidget(); // for offline, allows refresh twice
      _isTwice += 1;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    await fetchAndSetSpecificChapters(
            isOnline, _selectedTopicId, selectedProvince)
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
          : CustomScrollView(
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
                  bottom: PreferredSize(
                    child: NoInternetMessage(),
                    preferredSize: Size.lerp(
                      Size(double.maxFinite, 25), // fixed // offline
                      const Size(0, 0), // fixed // online
                      isOnline == 1 ? 1 : 0,
                    ),
                  ),
                ),
                (_error == "NoError")
                    ? SliverGrid.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        children: specificChapters
                            .map(
                              (chapter) => ChapterCard(
                                chapter: chapter,
                              ),
                            )
                            .toList(),
                      )
                    : SliverFillRemaining(
                        child: Retry(refreshWidget: _refreshWidget),
                      ),
              ],
            ),
    );
  }

  @override
  void deactivate() {
    _isLoading = true;
    clearChapters();
    super.deactivate();
  }
}
