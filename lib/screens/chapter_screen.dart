import 'package:flutter/material.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../widgets/retry.dart';
import '../widgets/no_internet_message.dart';
import '../widgets/coming_soon_message.dart';

class ChapterScreen extends StatelessWidget {
  static const routeName = "/chapter";
  static bool _isLoading = false;
  static String _error = "NoError";

  Future<void> _refreshWidget() async {
    // setState(() {
    //   _isLoading = true; // start loading screen again
    // });
    // await fetchAndSetSpecificChapters(
    //         isOnline, selectedTopic.id, selectedProvince)
    //     .catchError((error) {
    //   setState(() {
    //     _error = error;
    //     _isLoading = false;
    //   });
    // });
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
                  title: Text(
                    "${selectedChapter.title}",
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
                    ? SliverFillRemaining(
                        child: ComingSoonMessage(),
                      )
                    : SliverFillRemaining(
                        child: Retry(refreshWidget: _refreshWidget),
                      ),
              ],
            ),
    );
  }
}
