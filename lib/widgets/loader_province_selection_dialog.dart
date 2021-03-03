import 'package:flutter/material.dart';

import './province_selection_dialog.dart';
import 'error_message_dialog.dart';
import '../helpers/provinces.dart';

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
              return ProvinceSelectionDialog(provinces: _provinces);
            } else {
              return ErrorMessageDialog();
            }
          } else if (snapshot.hasError) {
            return ErrorMessageDialog();
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
