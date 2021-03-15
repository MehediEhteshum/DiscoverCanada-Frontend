import 'package:flutter/material.dart';

import '../widgets/selection_info.dart';

class ChaptersOverviewScreen extends StatelessWidget {
  static const routeName = "/chapters";

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            expandedHeight: 150,
            title: const Text("Chapters"),
            flexibleSpace: FlexibleSpaceBar(
              background: SelectionInfo(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Text(
                  "Chapters Grid jhsdfjhhgs jskdbfjsjbhdf jhbsdjfjhsb kjbsdjkfhkjs jkhskjfkjsh fjksbdfjsjhf jkshdf jhbsdfh hsjhfjs jksbdfjksfbjk sjkdfjkshf kjdbhfjgbdfbjgd sdfbgjdbfjhgbjdsh sjkdbfjsbjfhs jsdbfjsbjdfhbs jsdbfjhsbjfh",
                  softWrap: true,
                ),
                SizedBox(height: 2000)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
