import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';
import '../widgets/no_internet_message.dart';
import '../widgets/coming_soon_message.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../widgets/pdf_view_stack.dart';

class ChapterScreen extends StatefulWidget {
  static const routeName = "/chapter";

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  static String pdfUrl;
  static bool _hasPdf;

  @override
  void initState() {
    pdfUrl = selectedChapter.pdfUrl;
    _hasPdf = (pdfUrl != null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build _ChapterScreenState");

    return Scaffold(
      body: CustomScrollView(
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
              child: const NoInternetMessage(),
              preferredSize: Size.lerp(
                Size(double.maxFinite, 25), // fixed // offline
                const Size(0, 0), // fixed // online
                isOnline == 1 ? 1 : 0,
              ),
            ),
          ),
          SliverFillRemaining(
            child: _hasPdf ? const PdfViewStack() : ComingSoonMessage(),
          )
        ],
      ),
    );
  }
}
