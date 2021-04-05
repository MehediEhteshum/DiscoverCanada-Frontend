import 'package:flutter/material.dart';

import '../models and providers/topic.dart';
import '../models and providers/chapter.dart';

// const values
const int timeOut = 10; // seconds
const int successCode = 200; // success statusCode
const double errorIconSize = 50;
const Color errorIconColor = Colors.red;
const double fontSize1 = 20;
const double fontSize2 = 25;
const double cardElevation = 8;
const EdgeInsets cardMargin = EdgeInsets.all(10);
const List<int> topicIdsForAllProvincesOpt = [4];
const String noInternetImage = "assets/images/noInternet.jpg";

// global variables initialized
double screenWidth = 400;
double unitWidthFactor = screenWidth / 30; // unit width variable
BorderRadius cardBorderRadius = BorderRadius.circular(15);
List<Topic> topics = [];
List<String> provinces = [];
List<Chapter> specificChapters = [];
bool isOnline = false;

// global variables declared
Topic selectedTopic;
String selectedProvince;

const Widget ErrorTitle = Text(
  "ERROR: Content not found",
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
