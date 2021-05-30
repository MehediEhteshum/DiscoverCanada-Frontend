import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/base.dart';
import '../helpers/manage_files.dart';
import '../models and providers/internet_connectivity_provider.dart';
import '../models and providers/topic.dart';

class TopicImage extends StatefulWidget {
  const TopicImage({
    Key key,
    @required Topic topic,
    double imageHeight = double.infinity,
  })  : _topic = topic,
        _imageHeight = imageHeight,
        super(key: key);

  final Topic _topic;
  final double _imageHeight;

  @override
  _TopicImageState createState() => _TopicImageState();
}

class _TopicImageState extends State<TopicImage> {
  static bool _fileExists;
  static String _imageUrl;
  static String _filePath;
  static double _downloadProgress;
  static int _dummyTotal;
  static CancelToken _cancelToken;

  @override
  void initState() {
    _downloadProgress = 0;
    _dummyTotal = 3000000;
    _cancelToken = CancelToken();
    _filePath = getFilePath(fileTypes[0], widget._topic);
    _fileExists = File(_filePath).existsSync();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setStateIfMounted(() {
      isOnline = Provider.of<InternetConnectivity>(context).isOnline;
    });
    if (!_fileExists && isOnline == 1) {
      // fetch and save file from network when online
      _imageUrl = FlutterConfig.get('BASE_URL') + widget._topic.imageUrl;
      try {
        Dio()
            .download(
              _imageUrl,
              _filePath,
              onReceiveProgress: _calculateDownloadProgress,
              cancelToken: _cancelToken,
              options: Options(
                  responseType: ResponseType.bytes,
                  headers: {HttpHeaders.acceptEncodingHeader: "*"}),
            )
            .then((_) {
              _setStateIfMounted(() {
                _fileExists = File(_filePath).existsSync();
                if (_fileExists) {
                  _downloadProgress = 1;
                }
              });
            })
            .timeout(Duration(seconds: timeOut))
            .catchError((e) {
              print("topic_image1 $e");
              _setStateIfMounted(() {
                _downloadProgress = -1;
              });
            });
      } catch (e) {
        print("topic_image2 $e");
        _setStateIfMounted(() {
          _downloadProgress = -1;
        });
      }
    }
    if (_fileExists) {
      _downloadProgress = 1;
    }
    super.didChangeDependencies();
  }

  void _calculateDownloadProgress(received, total) {
    if (total != -1) {
      // 'total' value available
      _setStateIfMounted(() {
        _downloadProgress = received / total;
      });
    } else {
      // 'total' value unavailable. So, dummy progress
      _setStateIfMounted(() {
        _downloadProgress =
            (_downloadProgress < 0.95) ? received / _dummyTotal : 0.95;
      });
    }
  }

  void _setStateIfMounted(Function f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    _filePath = getFilePath(fileTypes[0], widget._topic);
    print("Memeory leaks? build _TopicImageState");

    return _fileExists
        ? FadeInImage(
            // load image from file
            placeholder: MemoryImage(kTransparentImage),
            image: FileImage(File(_filePath)),
            imageErrorBuilder: (_, __, ___) {
              return Image.asset(
                noInternetImage,
                height: widget._imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
            height: widget._imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : _downloadProgress >= 0 && _downloadProgress <= 1
            ? Image.memory(
                kTransparentImage,
                height: widget._imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.asset(
                noInternetImage,
                height: widget._imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              );
  }

  @override
  void dispose() {
    if (_downloadProgress < 1) {
      // download not complete
      _cancelToken.cancel("Download cancelled. Reason: widget closed.");
    }
    super.dispose();
  }
}
