import 'package:flutter/material.dart';

List<String> _testList = ["A", "B", "C"];
String _itemSelected = _testList[0];

class ProvinceSelectionDialog extends StatefulWidget {
  const ProvinceSelectionDialog({
    Key key,
  }) : super(key: key);

  @override
  _ProvinceSelectionDialogState createState() =>
      _ProvinceSelectionDialogState();
}

class _ProvinceSelectionDialogState extends State<ProvinceSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select a Province"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _testList
            .map(
              (e) => RadioListTile(
                title: Text(e),
                value: e,
                groupValue: _itemSelected,
                selected: _itemSelected == e,
                onChanged: (value) {
                  setState(() {
                    _itemSelected = value;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
