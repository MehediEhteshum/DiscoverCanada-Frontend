import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'error_message.dart';
import '../helpers/provinces.dart';

String _defaultSelectedProvince;

class LoaderProvinceSelectionDialog extends StatefulWidget {
  const LoaderProvinceSelectionDialog({
    Key key,
  }) : super(key: key);

  @override
  _LoaderProvinceSelectionDialogState createState() =>
      _LoaderProvinceSelectionDialogState();
}

class _LoaderProvinceSelectionDialogState
    extends State<LoaderProvinceSelectionDialog> {
  final ScrollController _provinceScrollontroller = ScrollController();
  Future<dynamic> _fetchProvinces;

  @override
  void initState() {
    super.initState();
    _fetchProvinces = fetchProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<dynamic>(
        future: _fetchProvinces,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var _provinces = snapshot.data;
            if (_provinces.length > 0) {
              _provinces = ["All Provinces", ..._provinces];
              _defaultSelectedProvince = _provinces[0];
              double _provinceListHeight =
                  MediaQuery.of(context).size.height * 2 / 3;
              double _percItemsVisible = (_provinceListHeight / 57) /
                  _provinces
                      .length; // each RadioListTile height is approx. 57 pixels
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
                          groupValue: _defaultSelectedProvince,
                          selected:
                              _defaultSelectedProvince == _provinces[index],
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
            } else {
              return ErrorMessage();
            }
          } else if (snapshot.hasError) {
            return ErrorMessage();
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
