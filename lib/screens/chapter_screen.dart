import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../widgets/retry.dart';
import '../widgets/no_internet_message.dart';
import '../widgets/coming_soon_message.dart';
import '../models and providers/internet_connectivity_provider.dart';

class ChapterScreen extends StatefulWidget {
  static const routeName = "/chapter";

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  static bool _isLoading = false;
  static String _error = "NoError";
  bool _containsPdf = (selectedChapter.pdfUrl != null);
  PdfController _pdfController;

  @override
  void initState() {
    if (_containsPdf) {
      print("pdf chapter");
      _pdfController = PdfController(
        document: PdfDocument.openAsset('assets/pdfs/sample.pdf'),
      );
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
      _refreshWidget(); // as soon as online/offline, it refreshes widget
    });
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
                  pinned: true,
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
                        child: _containsPdf
                            ? PdfView(
                                controller: _pdfController,
                                documentLoader: Center(
                                  child: const CircularProgressIndicator(),
                                ),
                                pageLoader: Center(
                                  child: const CircularProgressIndicator(),
                                ),
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                              )
                            : ComingSoonMessage(),
                      )
                    : SliverFillRemaining(
                        child: Retry(refreshWidget: _refreshWidget),
                      ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    if (_containsPdf) {
      _pdfController.dispose();
    }
    super.dispose();
  }
}
