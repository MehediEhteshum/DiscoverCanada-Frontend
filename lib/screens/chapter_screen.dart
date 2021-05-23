import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  static String _pdfUrl;
  static String _webUrl;
  static bool _hasPdfUrl;
  static bool _hasWebUrl;

  @override
  void initState() {
    _pdfUrl = selectedChapter.pdfUrl;
    _webUrl = selectedChapter.webUrl;
    _hasPdfUrl = (_pdfUrl != null);
    _hasWebUrl = (_webUrl != null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setStateIfMounted(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    super.didChangeDependencies();
  }

  void _setStateIfMounted(Function f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build _ChapterScreenState");

    return Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "${selectedChapter.title}",
              softWrap: true,
            ),
            pinned: true,
            expandedHeight: 0,
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
            child: _hasPdfUrl
                ? const PdfViewStack()
                : _hasWebUrl
                    ? WebView(
                        initialUrl: _webUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                      )
                    : ComingSoonMessage(),
          )
        ],
      ),
    );
  }
}
