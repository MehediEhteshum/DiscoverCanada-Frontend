import 'package:flutter/material.dart';

const int timeOut = 10; // seconds
const int successCode = 200; // success statusCode
const double errorIconSize = 50;
const Color errorIconColor = Colors.red;
const double fontSize1 = 20;
const double fontSize2 = 25;
const List<int> topicIdsForAllProvincesOpt = [4];

double screenWidth = 400;
double unitWidthFactor = screenWidth / 30; // unit width variable

const Widget ErrorTitle = Text(
  "ERROR 404: Content not found",
  textAlign: TextAlign.center,
  softWrap: true,
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: fontSize2, // fixed dim
    color: errorIconColor,
  ),
);

const Widget ErrorIcon = Icon(
  Icons.warning,
  size: errorIconSize, // fixed dim
  color: errorIconColor,
);
