import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../widgets/retry.dart';
import '../widgets/no_internet_message.dart';
import '../widgets/coming_soon_message.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../widgets/pdf_view_builder.dart';

class ChapterScreen extends StatefulWidget {
  static const routeName = "/chapter";

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  static bool _isLoading = false;
  static String _error = "NoError";
  String pdfUrl = selectedChapter.pdfUrl;
  bool _hasPdf;
  static int _isTwice = 0;

  @override
  void initState() {
    _hasPdf = (pdfUrl != null);
    _refreshWidget(); // used for refresh widget and fetch items
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
      _refreshWidget(); // as soon as online/offline, it refreshes widget
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
    print("Memeory leaks? build _ChapterScreenState");

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
                  pinned: true,
                  expandedHeight: screenWidth *
                      0.4, // proportional to screen width = AppBar kToolbarHeight + Chapter title w/ extra 1 line + Province name + Bottom padding statusbarHeight
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
                        child: _hasPdf ? PdfViewBuilder() : ComingSoonMessage(),
                      )
                    : SliverFillRemaining(
                        child: Retry(refreshWidget: _refreshWidget),
                      ),
              ],
            ),
    );
  }
}
