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
  static PdfController _pdfController;
  static TextEditingController _textEditingController;
  static bool _fileExists;
  static int _allPagesCount;
  static String _pdfUrl;
  static String _filePath;
  static double _downloadProgress;
  static int _dummyTotal;
  static CancelToken _cancelToken;

  @override
  void initState() {
    _pdfController = PdfController(document: null);
    _textEditingController = TextEditingController();
    // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    _downloadProgress = 0;
    _dummyTotal = 3500000;
    _cancelToken = CancelToken();
    _filePath = getFilePath(fileTypes[1]);
    _fileExists = File(_filePath).existsSync();
    _textEditingController.text = "1";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setStateIfMounted(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    if (!_fileExists && isOnline == 1) {
      // fetch and save file from network when online
      _pdfUrl = selectedChapter.pdfUrl;
      try {
        Dio()
            .download(
          _pdfUrl,
          _filePath,
          onReceiveProgress: _calculateDownloadProgress,
          cancelToken: _cancelToken,
          options: Options(
              responseType: ResponseType.bytes,
              headers: {HttpHeaders.acceptEncodingHeader: "*"}),
        )
            .then((_) {
          _setStateIfMounted(() {
            _fileExists = File(_filePath).existsSync();
            if (_fileExists) {
              // load from file
              _downloadProgress = 1;
              _pdfController.document = PdfDocument.openFile(_filePath);
              // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
            }
          });
        });
      } catch (e) {
        print("pdf_view_stack1 $e");
      }
    }
    if (_fileExists) {
      // load from file
      _downloadProgress = 1;
      _pdfController.document = PdfDocument.openFile(_filePath);
      // Learning: first initialize controllers, then set value only if required to avoid unexpected error i.e. avoid re-initializing controllers.
    }
    super.didChangeDependencies();
  }

  void _calculateDownloadProgress(received, total) {
    if (total != -1) {
      // 'total' value available
      _setStateIfMounted(() {
        _downloadProgress = received / total;
      });
    } else {
      // 'total' value unavailable. So, dummy progress
      _setStateIfMounted(() {
        _downloadProgress =
            (_downloadProgress < 0.95) ? received / _dummyTotal : 0.95;
      });
    }
  }

  void _setStateIfMounted(Function f) {
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
          )
        : Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  value: _downloadProgress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.black,
                ),
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
    if (_downloadProgress < 1) {
      // download not complete
      _cancelToken.cancel("Download cancelled. Reason: widget closed.");
    }
    _pdfController?.dispose(); // null safety
    _textEditingController.dispose();
    super.dispose();
  }
}
