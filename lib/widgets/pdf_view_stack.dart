import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import '../helpers/base.dart';
import '../helpers/manage_files.dart';
import '../helpers/manage_pdf_files.dart';
import './pdf_navigation_controller.dart';

class PdfViewStack extends StatefulWidget {
  const PdfViewStack({
    Key key,
  }) : super(key: key);

  @override
  _PdfViewStackState createState() => _PdfViewStackState();
}

class _PdfViewStackState extends State<PdfViewStack> {
  final PdfController _pdfController = PdfController(document: null);
  final TextEditingController _inputController = TextEditingController();
  // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
  static bool _pathExists;
  static bool _fileExists;
  static int _allPagesCount;
  static int _selectedChapterId;
  static String _pdfUrl;
  static String folderPath;
  static String fileName;
  static String filePath;

  @override
  void initState() {
    _selectedChapterId = selectedChapter.id;
    _pdfUrl = selectedChapter.pdfUrl;
    _pathExists = chapterPdfPathsList != null
        ? chapterPdfPathsList.asMap().containsKey(_selectedChapterId)
        : false; // for some reason, becomes null when new province is selected
    if (!_pathExists) {
      // chapterPdfPathsList is empty or not ready at this point. hence, again generate filePath manually;
      folderPath = appDocDir.path + "/" + "pdfs" + "/";
      fileName = selectedChapter.title + ".pdf";
      filePath = folderPath + fileName;
    } else {
      // chapterPdfPathsList is ready or contains path
      filePath = chapterPdfPathsList[_selectedChapterId];
    }
    _fileExists = File(filePath).existsSync();
    _inputController.text = "1";
    // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies1");
    print("$_selectedChapterId $_pdfUrl");
    setChapterPdfPathsList();
    if (!_fileExists) {
      // fetch and save file from network
      print("didChangeDependencies2");
      Dio()
          .get(
        _pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      )
          .then((response) {
        File _file = File(filePath);
        _file.writeAsBytes(response.data).then((file) {
          if (mounted) {
            setState(() {
              _fileExists = File(filePath).existsSync(); // state
              print("_fileExists1 $_fileExists");
              if (_fileExists) {
                print("_fileExists2 $_fileExists");
                _pdfController.document = PdfDocument.openFile(filePath);
                // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
              }
              print("didChangeDependencies3");
            });
          }
        });
      });
    }
    if (_fileExists) {
      // load from file
      print("didChangeDependencies4");
      print("_pathExists $_pathExists");
      print("$_selectedChapterId $chapterPdfPathsList");
      _pdfController.document = PdfDocument.openFile(filePath);
      // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _PdfViewStackState");

    return _fileExists
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
                    _inputController.text =
                        "$pageNumber"; // when page is changed using button
                  });
                },
              ),
              PdfNavigationController(
                pdfController: _pdfController,
                inputController: _inputController,
                allPagesCount: _allPagesCount,
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _inputController.dispose();
    super.dispose();
  }
}
