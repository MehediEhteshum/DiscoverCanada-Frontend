import 'package:flutter/material.dart';

import '../helpers/base.dart';
import '../widgets/selection_info.dart';

class ChaptersOverviewScreen extends StatelessWidget {
  static const routeName = "/chapters";

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build ChaptersOverviewScreen");
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "Chapters",
              softWrap: true,
            ),
            floating: true,
            expandedHeight: screenWidth *
                0.4, // proportional to screen width = AppBar kToolbarHeight + Topic title w/ extra 1 line + Province name + Bottom padding statusbarHeight
            flexibleSpace: const FlexibleSpaceBar(
              background: const SelectionInfo(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: const <Widget>[
                const Text(
                  "Chapters Grid jhsdfjhhgs jskdbfjsjbhdf jhbsdjfjhsb kjbsdjkfhkjs jkhskjfkjsh fjksbdfjsjhf jkshdf jhbsdfh hsjhfjs jksbdfjksfbjk sjkdfjkshf kjdbhfjgbdfbjgd sdfbgjdbfjhgbjdsh sjkdbfjsbjfhs jsdbfjsbjdfhbs jsdbfjhsbjfh",
                  softWrap: true,
                  style: TextStyle(fontSize: fontSize1),
                ),
                const SizedBox(height: 2000)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
