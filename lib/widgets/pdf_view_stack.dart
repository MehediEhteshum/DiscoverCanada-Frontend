import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import './pdf_navigation_controller.dart';

class PdfViewStack extends StatefulWidget {
  const PdfViewStack({
    Key key,
  }) : super(key: key);

  @override
  _PdfViewStackState createState() => _PdfViewStackState();
}

class _PdfViewStackState extends State<PdfViewStack> {
  int _allPagesCount;
  PdfController _pdfController;
  TextEditingController _inputController;

  @override
  void initState() {
    _pdfController = PdfController(
        document: PdfDocument.openAsset('assets/pdfs/sample.pdf'));
    _inputController = TextEditingController(text: "1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _PdfViewStackState");

    return Stack(
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
              _inputController.text = "$pageNumber"; // when page is changed using button
            });
          },
        ),
        PdfNavigationController(
          pdfController: _pdfController,
          inputController: _inputController,
          allPagesCount: _allPagesCount,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _inputController.dispose();
    super.dispose();
  }
}
