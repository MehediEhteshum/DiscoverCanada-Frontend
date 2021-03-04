import 'package:flutter/material.dart';

int timeOut = 3; // seconds
int successCode = 200; // success statusCode

const Widget ErrorTitle = Text(
  "ERROR 404: Content not found",
  textAlign: TextAlign.center,
  softWrap: true,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
  ),
);
