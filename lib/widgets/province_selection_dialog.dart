import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import '../helpers/base.dart';
import '../screens/chapters_overview_screen.dart';

class ProvinceSelectionDialog extends StatefulWidget {
  const ProvinceSelectionDialog({
    Key key,
  }) : super(key: key);

  @override
  _ProvinceSelectionDialogState createState() =>
      _ProvinceSelectionDialogState();
}

class _ProvinceSelectionDialogState extends State<ProvinceSelectionDialog> {
  final ScrollController _provinceScrollController = ScrollController();
  static String _selectedProvinceName;

  @override
  void initState() {
    _selectedProvinceName = provinces[0]; // default
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _ProvinceSelectionDialogState");
    double _provinceListHeight =
        screenWidth * 9 / 10; // proportional to screen width
    double _percItemsVisible = (_provinceListHeight / 57) /
        provinces.length; // each RadioListTile height is approx. 57 pixels

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${selectedTopic.title}",
            softWrap: true,
            style: const TextStyle(
              fontSize: fontSize2, // fixed dim
            ),
          ),
          const SizedBox(height: 15), // fixed dim
          const Text(
            "Select a Province",
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: fontSize1, // fixed dim
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0), // fixed dim
      content: Container(
        width: double.maxFinite,
        height: _provinceListHeight, // proportional to screen width
        child: DraggableScrollbar.rrect(
          heightScrollThumb: _provinceListHeight *
              _percItemsVisible, // proportional to screen width
          backgroundColor: Colors.grey,
          alwaysVisibleScrollThumb: true,
          controller: _provinceScrollController,
          child: ListView.builder(
            controller: _provinceScrollController,
            itemCount: provinces.length,
            itemBuilder: (BuildContext _, int index) {
              return RadioListTile(
                title: Text(
                  provinces[index],
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: fontSize1 * 0.85, // fixed dim
                  ),
                ),
                value: provinces[index],
                groupValue: _selectedProvinceName,
                selected: _selectedProvinceName == provinces[index],
                onChanged: (value) {
                  setState(() {
                    _selectedProvinceName = value;
                  });
                },
              );
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Continue',
            style: const TextStyle(
              fontSize: fontSize1, // fixed dim
            ),
            softWrap: true,
          ),
          onPressed: () {
            selectedProvince = _selectedProvinceName;
            Navigator.of(context)
                .popAndPushNamed(ChaptersOverviewScreen.routeName);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _provinceScrollController.dispose();
    super.dispose();
  }
}
