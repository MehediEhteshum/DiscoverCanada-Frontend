import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import '../helpers/manage_files.dart';
import '../models and providers/internet_connectivity_provider.dart';
import './download_progress_container.dart';
import './download_exit_confirmation_dialog.dart';
import './pdf_view_stack.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    Key key,
  }) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  static bool _fileExists;
  static String _pdfUrl;
  static String _filePath;
  static double _downloadProgress;
  static int _dummyTotal;
  static CancelToken _cancelToken;

  @override
  void initState() {
    _downloadProgress = 0;
    _dummyTotal = 3500000;
    _cancelToken = CancelToken();
    _filePath = getFilePath(fileTypes[1]);
    _fileExists = File(_filePath).existsSync();
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
            }
          });
        });
      } catch (e) {
        print("pdf_viewer1 $e");
      }
    }
    if (_fileExists) {
      // load from file
      _downloadProgress = 1;
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
    return WillPopScope(
      onWillPop: _willPop,
      child: _fileExists
          ? PdfViewStack(
              filePath: _filePath,
            )
          : DownloadProgressContainer(downloadProgress: _downloadProgress),
    );
  }

  Future<bool> _willPop() async {
    final value = (_downloadProgress < 1)
        // download not complete. alert.
        ? await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return const DownloadExitConfirmationDialog();
            },
          )
        : true;
    return value == true;
  }

  @override
  void dispose() {
    if (_downloadProgress < 1) {
      // download not complete
      _cancelToken.cancel("Download cancelled. Reason: widget closed.");
    }
    super.dispose();
  }
}
