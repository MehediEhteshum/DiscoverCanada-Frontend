import 'package:flutter/material.dart';

class Topic {
  final int id;
  final String title;
  final String imageUrl;
  final bool isProvinceDependent;

  Topic({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.isProvinceDependent,
  });
}
