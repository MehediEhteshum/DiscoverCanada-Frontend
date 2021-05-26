import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({
    Key key,
    @required String webUrl,
  })  : _webUrl = webUrl,
        super(key: key);

  final String _webUrl;

  @override
  _WebViewStackState createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  static bool _isLoadingWebUrl;

  @override
  void initState() {
    _isLoadingWebUrl = true;
    super.initState();
  }

  void _setStateIfMounted(Function f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _WebViewStackState");

    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: widget._webUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (finish) {
            _setStateIfMounted(() {
              _isLoadingWebUrl = false;
            });
          },
        ),
        _isLoadingWebUrl
            ? const Center(
                child: const CircularProgressIndicator(),
              )
            : Container(), // dummy placeholder
      ],
    );
  }
}
