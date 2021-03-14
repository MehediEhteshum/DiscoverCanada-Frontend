import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/chapters_overview_screen.dart';
import '../models and providers/selected_topic_provider.dart';
import '../models and providers/selected_province_provider.dart';

class ProvinceSelectionDialog extends StatefulWidget {
  const ProvinceSelectionDialog({
    Key key,
    @required this.provinces,
  }) : super(key: key);

  final List<dynamic> provinces;

  @override
  _ProvinceSelectionDialogState createState() =>
      _ProvinceSelectionDialogState();
}

class _ProvinceSelectionDialogState extends State<ProvinceSelectionDialog> {
  final ScrollController _provinceScrollontroller = ScrollController();
  String _defaultSelectedProvince = "All Provinces";

  @override
  Widget build(BuildContext context) {
    double _provinceListHeight = MediaQuery.of(context).size.height * 3 / 5;
    double _percItemsVisible = (_provinceListHeight / 57) /
        widget
            .provinces.length; // each RadioListTile height is approx. 57 pixels

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<SelectedTopic>(
            builder: (ctx, selectedTopic, _) {
              return Text(
                "${selectedTopic.title}",
                softWrap: true,
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            "Select a Province",
            softWrap: true,
            textScaleFactor: 0.90,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
      content: Container(
        width: double.maxFinite,
        height: _provinceListHeight,
        child: DraggableScrollbar.rrect(
          heightScrollThumb: _provinceListHeight * _percItemsVisible,
          backgroundColor: Colors.grey,
          alwaysVisibleScrollThumb: true,
          controller: _provinceScrollontroller,
          child: ListView.builder(
            controller: _provinceScrollontroller,
            itemCount: widget.provinces.length,
            itemBuilder: (BuildContext _, int index) {
              return RadioListTile(
                title: Text(
                  widget.provinces[index],
                  softWrap: true,
                ),
                value: widget.provinces[index],
                groupValue: _defaultSelectedProvince,
                selected: _defaultSelectedProvince == widget.provinces[index],
                onChanged: (value) {
                  setState(() {
                    Provider.of<SelectedProvince>(context, listen: false)
                        .selectProvince(value);
                    _defaultSelectedProvince = value;
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
            style: const TextStyle(fontSize: 17),
            softWrap: true,
          ),
          onPressed: () {
            Navigator.of(context)
                .popAndPushNamed(ChaptersOverviewScreen.routeName);
          },
        ),
      ],
    );
  }
}
