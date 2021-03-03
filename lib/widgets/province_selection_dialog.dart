import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

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
    double _provinceListHeight = MediaQuery.of(context).size.height * 2 / 3;
    double _percItemsVisible = (_provinceListHeight / 57) /
        widget
            .provinces.length; // each RadioListTile height is approx. 57 pixels

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
            itemCount: widget.provinces.length,
            itemBuilder: (BuildContext _, int index) {
              return RadioListTile(
                title: Text(widget.provinces[index]),
                value: widget.provinces[index],
                groupValue: _defaultSelectedProvince,
                selected: _defaultSelectedProvince == widget.provinces[index],
                onChanged: (value) {
                  setState(() {
                    _defaultSelectedProvince = value;
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
