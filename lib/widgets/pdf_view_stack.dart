import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../helpers/manage_files.dart';
import './pdf_navigation_controller.dart';
import '../models and providers/internet_connectivity_provider.dart';

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
  static bool _fileExists;
  static int _allPagesCount;
  static String _pdfUrl;
  static String _filePath;

  @override
  void initState() {
    _filePath = getFilePath(fileTypes[1]);
    _fileExists = File(_filePath).existsSync();
    _inputController.text = "1";
    // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setStateIfMounted(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    if (!_fileExists && isOnline == 1) {
      // fetch and save file from network when online
      _pdfUrl = selectedChapter.pdfUrl;
      Dio()
          .get(
        _pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      )
          .then((response) {
        File _file = File(_filePath);
        _file.writeAsBytes(response.data).then((file) {
          setStateIfMounted(() {
            _fileExists = File(_filePath).existsSync(); // state
            if (_fileExists) {
              _pdfController.document = PdfDocument.openFile(_filePath);
              // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
            }
          });
        });
      });
    }
    if (_fileExists) {
      // load from file
      _pdfController.document = PdfDocument.openFile(_filePath);
      // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    }
    super.didChangeDependencies();
  }

  void setStateIfMounted(Function f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _PdfViewStackState");

    return _fileExists
        ? Stack(
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
                  setStateIfMounted(() {
                    _allPagesCount = document.pagesCount;
                  });
                },
                onPageChanged: (pageNumber) {
                  setStateIfMounted(() {
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
        : Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Make sure you have internet access.",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize1,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Please wait. Download may take several minutes to finish.",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize1,
                  ),
                ),
              ],
            ),
          );
  }

  @override
  void dispose() {
    _pdfController?.dispose(); // null safety
    _inputController.dispose();
    super.dispose();
  }
}
