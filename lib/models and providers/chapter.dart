import 'package:flutter/material.dart';

class Chapter {
  final int id;
  final String title;
  final String pdfUrl;
  final String webUrl;

  Chapter({
    @required this.id,
    @required this.title,
    @required this.pdfUrl,
    @required this.webUrl,
  });
}
