import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import './pdf_navigation_controller.dart';

class PdfViewStack extends StatefulWidget {
  const PdfViewStack({
    Key key,
    @required String filePath,
  })  : _filePath = filePath,
        super(key: key);

  final String _filePath;

  @override
  _PdfViewStackState createState() => _PdfViewStackState();
}

class _PdfViewStackState extends State<PdfViewStack> {
  static PdfController _pdfController;
  static TextEditingController _textEditingController;
  static int _allPagesCount;

  @override
  void initState() {
    _pdfController = PdfController(document: null);
    _textEditingController = TextEditingController();
    // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    _pdfController.document = PdfDocument.openFile(widget._filePath);
    _textEditingController.text = "1";
    _allPagesCount = 1;
    super.initState();
  }

  void _setStateIfMounted(Function f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _PdfViewStackState");

    return Stack(
      children: <Widget>[
        PdfView(
          controller: _pdfController,
          documentLoader: const Center(
            child: const CircularProgressIndicator(),
          ),
          pageLoader: const Center(
            child: const CircularProgressIndicator(),
          ),
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onDocumentLoaded: (document) {
            _setStateIfMounted(() {
              _allPagesCount = document.pagesCount;
            });
          },
          onPageChanged: (pageNumber) {
            _setStateIfMounted(() {
              _textEditingController.text =
                  "$pageNumber"; // when page is changed using button
            });
          },
        ),
        PdfNavigationController(
          pdfController: _pdfController,
          textEditingController: _textEditingController,
          allPagesCount: _allPagesCount,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose(); // null safety
    _textEditingController.dispose();
    super.dispose();
  }
}
