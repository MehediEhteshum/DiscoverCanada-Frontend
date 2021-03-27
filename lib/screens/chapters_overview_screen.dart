import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../models and providers/specific_chapters_provider.dart';
import '../models and providers/selected_topic_provider.dart';
import '../models and providers/selected_province_provider.dart';
import '../widgets/retry.dart';

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
      final int _topicId = fetchParams()["topicId"];
      final String _provinceName = fetchParams()["provinceName"];
      Provider.of<SpecificChapters>(context)
          .fetchAndSetSpecificChapters(_topicId, _provinceName)
          .catchError((error) {
        setState(() {
          _error = error;
          _isLoading = false;
        });
      }); // need to listen it
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Map<String, dynamic> fetchParams() {
    final int _topicId =
        Provider.of<SelectedTopic>(context, listen: false).topicId;
    final String _provinceName =
        Provider.of<SelectedProvince>(context, listen: false).provinceName;
    return {
      "topicId": _topicId,
      "provinceName": _provinceName,
    };
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    final int _topicId = fetchParams()["topicId"];
    final String _provinceName = fetchParams()["provinceName"];
    Provider.of<SpecificChapters>(context, listen: false)
        .fetchAndSetSpecificChapters(_topicId, _provinceName)
        .catchError((error) {
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }); // need to ignore listen here
  }

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build ChaptersOverviewScreen");

    return Scaffold(
      body: _isLoading
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : (_error == "NoError")
              ? CustomScrollView(
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
                    Consumer<SpecificChapters>(
                      builder: (ctx, specificChapters, _) {
                        return SliverGrid.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          children: specificChapters.chaptersList
                              .map(
                                (chapter) => Card(
                                  color: Colors.blue,
                                  shadowColor: Colors.grey,
                                  elevation: 8, // fixed dim
                                  margin: const EdgeInsets.all(10), // fixed dim
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // fixed dim
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(15),
                                    child: AutoSizeText(
                                      "${chapter.title}",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      maxLines: 4,
                                      maxFontSize: fontSize1,
                                      minFontSize: 15,
                                      style: TextStyle(
                                        fontSize: fontSize1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),

                    // SliverToBoxAdapter(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Consumer<SpecificChapters>(
                    //         builder: (ctx, specificChapters, _) {
                    //           return Text(
                    //             "${specificChapters.chaptersList[0].title}",
                    //             softWrap: true,
                    //             style: TextStyle(fontSize: fontSize1),
                    //           );
                    //         },
                    //       ),
                    //       const SizedBox(height: 2000)
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              : Retry(refreshWidget: _refreshWidget),
    );
  }

  @override
  void deactivate() {
    _isLoading = true;
    _isInit = true;
    Provider.of<SpecificChapters>(context, listen: false).clearChapters();
    super.deactivate();
  }
}
