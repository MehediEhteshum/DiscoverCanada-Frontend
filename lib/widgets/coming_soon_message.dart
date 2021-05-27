import 'package:flutter/material.dart';

import '../helpers/base.dart';

class ComingSoonMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text(
        "Coming Soon",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize2,
        ),
      ),
    );
  }
}
