import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../helpers/specific_chapters.dart';
import '../widgets/retry.dart';
import '../widgets/chapter_card.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../widgets/no_internet_message.dart';

class ChaptersOverviewScreen extends StatefulWidget {
  static const routeName = "/chapters";

  @override
  _ChaptersOverviewScreenState createState() => _ChaptersOverviewScreenState();
}

class _ChaptersOverviewScreenState extends State<ChaptersOverviewScreen> {
  static bool _isLoading = true;
  static String _error;

  @override
  void didChangeDependencies() {
    setState(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
      _refreshWidget(); // as soon as online/offline, it refreshes widget
    });
    super.didChangeDependencies();
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    await fetchAndSetSpecificChapters(
            isOnline, selectedTopic.id, selectedProvince)
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
