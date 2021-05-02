import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _hasPdf = (selectedChapter.pdfUrl != null);
  int _allPagesCount;
  PdfController _pdfController;
  TextEditingController _inputController;
  static int _isTwice = 0;

  @override
  void initState() {
    if (_hasPdf) {
      _pdfController = PdfController(
          document: PdfDocument.openAsset('assets/pdfs/sample.pdf'));
      _inputController = TextEditingController(text: "1");
    }
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
                        child: _hasPdf
                            ? Stack(
                                children: <Widget>[
                                  PdfView(
                                    controller: _pdfController,
                                    documentLoader: Center(
                                      child: const CircularProgressIndicator(),
                                    ),
                                    pageLoader: Center(
                                      child: const CircularProgressIndicator(),
                                    ),
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    onDocumentLoaded: (document) {
                                      setState(() {
                                        _allPagesCount = document.pagesCount;
                                      });
                                    },
                                    onPageChanged: (pageNumber) {
                                      setState(() {
                                        _inputController.text = "$pageNumber";
                                      });
                                    },
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    width: screenWidth,
                                    child: Container(
                                      color: Colors.black12,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                            icon: const ImageIcon(
                                              AssetImage(
                                                  "assets/images/double_up_arrow.png"),
                                            ),
                                            iconSize: 30,
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              _pdfController.animateToPage(
                                                1,
                                                curve: Curves.ease,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const ImageIcon(
                                              AssetImage(
                                                  "assets/images/up_arrow.png"),
                                            ),
                                            iconSize: 30,
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              _pdfController.previousPage(
                                                curve: Curves.ease,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            },
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                30, 0, 30, 0),
                                            child: Row(
                                              children: <Widget>[
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          screenWidth * 0.25),
                                                  child: IntrinsicWidth(
                                                    child: TextFormField(
                                                      controller:
                                                          _inputController,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: fontSize1),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            const OutlineInputBorder(),
                                                        isDense:
                                                            true, // Added this
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 5, 10, 5),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      onFieldSubmitted: (page) {
                                                        int pageNumber =
                                                            int.tryParse(
                                                                    page) ??
                                                                1;
                                                        pageNumber = pageNumber <
                                                                1
                                                            ? 1
                                                            : pageNumber >
                                                                    _allPagesCount
                                                                ? _allPagesCount
                                                                : pageNumber;
                                                        _pdfController
                                                            .jumpToPage(
                                                                pageNumber);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ' /$_allPagesCount',
                                                  style: const TextStyle(
                                                      fontSize: fontSize1),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const ImageIcon(
                                              AssetImage(
                                                  "assets/images/down_arrow.png"),
                                            ),
                                            iconSize: 30,
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              _pdfController.nextPage(
                                                curve: Curves.ease,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: ImageIcon(
                                              AssetImage(
                                                  "assets/images/double_down_arrow.png"),
                                            ),
                                            iconSize: 30,
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              _pdfController.animateToPage(
                                                _allPagesCount,
                                                curve: Curves.ease,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
    if (_hasPdf) {
      _pdfController.dispose();
    }
    super.dispose();
  }
}
