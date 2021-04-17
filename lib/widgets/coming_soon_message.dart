import 'package:flutter/material.dart';

import '../helpers/base.dart';

class ComingSoonMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Coming Soon",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize2,
        ),
      ),
    );
  }
}
