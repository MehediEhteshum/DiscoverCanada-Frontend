import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import './province_selection_dialog.dart';
import 'error_message_dialog.dart';
import '../helpers/provinces.dart';
import '../models and providers/selected_topic_provider.dart';

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
    _fetchProvinces = fetchProvinces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _LoaderProvinceSelectionDialogState");
    int _selectedTopicId = Provider.of<SelectedTopic>(context).topicId;

    return Center(
      child: FutureBuilder<dynamic>(
        future: _fetchProvinces,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var _provinces = snapshot.data;
            if (_provinces.length > 0) {
              if (topicIdsForAllProvincesOpt.contains(_selectedTopicId)) {
                // adding "All Provinces" option only when necessary
                _provinces = ["All Provinces", ..._provinces];
              }
              return ProvinceSelectionDialog(provinces: _provinces);
            } else {
              return const ErrorMessageDialog();
            }
          } else if (snapshot.hasError) {
            return const ErrorMessageDialog();
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
