import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/base.dart';

import './pdf_view_stack.dart';

class PdfViewBuilder extends StatelessWidget {
  const PdfViewBuilder({
    Key key,
  }) : super(key: key);

  static bool _pathExists, _fileExists;

  Future<bool> _checkIfFileExists() async {
    return _pathExists
        ? await File((chapterPdfPathsList[selectedChapter.id])).exists()
        : Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    _pathExists = (chapterPdfPathsList.asMap().containsKey(selectedChapter.id));
    print("Memeory leaks? build _PdfViewBuilderState");

    return FutureBuilder(
      future: _checkIfFileExists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _fileExists = snapshot.data;
          return PdfViewStack(fileExists: _fileExists);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: File Not Found',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize2,
                color: Colors.red,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
