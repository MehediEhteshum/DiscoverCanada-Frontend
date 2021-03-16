import 'package:flutter/material.dart';

import '../widgets/selection_info.dart';

class ChaptersOverviewScreen extends StatelessWidget {
  static const routeName = "/chapters";

  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build ChaptersOverviewScreen");
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: const Text("Chapters"),
            floating: true,
            expandedHeight:
                150, // AppBar kToolbarHeight + Topic title 25 + Province name 20 + Bottom padding statusbarHeight + extra 25
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
