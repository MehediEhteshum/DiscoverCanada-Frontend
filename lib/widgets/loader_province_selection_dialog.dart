import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/base.dart';
import './province_selection_dialog.dart';
import 'error_message_dialog.dart';
import '../helpers/provinces.dart';
import '../models and providers/internet_connectivity_provider.dart';

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
  static bool _isLoading = true;
  static String _error;
  final int _selectedTopicId = selectedTopic.id;

  @override
  void didChangeDependencies() {
    if (mounted) {
      setState(() {
        isOnline = Provider.of<InternetConnectivity>(context).isOnline;
        _refreshWidget(); // as soon as online/offline, it refreshes widget
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshWidget() async {
    setState(() {
      _isLoading = true; // start loading screen again
    });
    await fetchProvinces(isOnline).catchError((error) {
      setState(() {
        _error = error;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build _LoaderProvinceSelectionDialogState");

    if (topicIdsForAllProvincesOpt.contains(_selectedTopicId)) {
      // adding "All Provinces" option only when necessary
      provinces = ["All Provinces", ...provinces];
    }

    return _isLoading
        ? const Center(
            child: const CircularProgressIndicator(),
          )
        : (_error == "NoError")
            ? Center(
                child: ProvinceSelectionDialog(),
              )
            : const ErrorMessageDialog();
  }
}
