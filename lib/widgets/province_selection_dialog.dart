import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

List<String> _provinces = [
  "All Provinces",
  "Alberta",
  "British Columbia",
  "Manitoba",
  "New Brunswick",
  "Newfoundland and Labrador",
  "Nova Scotia",
  "Ontario",
  "Prince Edward Island",
  "Quebec",
  "Saskatchewan"
];
String _selectedProvince = _provinces[0];

class ProvinceSelectionDialog extends StatefulWidget {
  const ProvinceSelectionDialog({
    Key key,
  }) : super(key: key);

  @override
  _ProvinceSelectionDialogState createState() =>
      _ProvinceSelectionDialogState();
}

class _ProvinceSelectionDialogState extends State<ProvinceSelectionDialog> {
  final ScrollController _provinceScrollontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double _provinceListHeight = MediaQuery.of(context).size.height * 2 / 3;
    double _percItemsVisible = (_provinceListHeight / 57) /
        _provinces.length; // each item height is approx. 57 pixels
    return AlertDialog(
      title: Text("Select a Province"),
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
            itemCount: _provinces.length,
            itemBuilder: (BuildContext _, int index) {
              return RadioListTile(
                title: Text(_provinces[index]),
                value: _provinces[index],
                groupValue: _selectedProvince,
                selected: _selectedProvince == _provinces[index],
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
