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
    @required this.topic,
    this.imageHeight = double.infinity,
  }) : super(key: key);

  final Topic topic;
  final double imageHeight;

  @override
  _TopicImageState createState() => _TopicImageState();
}

class _TopicImageState extends State<TopicImage> {
  static bool _pathExists;
  static bool _fileExists;
  static Topic _topic;
  static int _topicId;
  static String _imageUrl;
  static String _folderPath;
  static String _fileName;
  static String _filePath;
  static RegExp _fileNameRegExp;

  @override
  void initState() {
    _topic = widget.topic;
    _topicId = _topic.id - 1; // topic index = topicId - 1
    _imageUrl = _topic.imageUrl;
    _pathExists = topicImagePathsList.isNotEmpty
        // avoiding Error of calling '.length' on []
        ? topicImagePathsList.asMap().containsKey(_topicId)
        : false;
    if (!_pathExists) {
      // topicImagePathsList is empty or not ready at this point. hence, again generate filePath manually;
      _folderPath = appDocDir.path + "/" + "images" + "/";
      _fileNameRegExp = RegExp(r"\w*\d*\.\w*");
      _fileName = _fileNameRegExp.stringMatch(_imageUrl);
      _filePath = _folderPath + _fileName;
    } else {
      // topicImagePathsList is ready or contains path
      _filePath = topicImagePathsList[_topicId];
    }
    _fileExists = File(_filePath).existsSync();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      setState(() {
        isOnline = Provider.of<InternetConnectivity>(context).isOnline;
      });
    }
    if (!_fileExists && isOnline == 1) {
      // fetch and save file from network when online
      Dio()
          .get(
        FlutterConfig.get('BASE_URL') + _imageUrl,
        options: Options(responseType: ResponseType.bytes),
      )
          .then((response) {
        _topic = widget.topic;
        _topicId = _topic.id - 1; // topic index = topicId - 1
        _imageUrl = _topic.imageUrl;
        _pathExists = topicImagePathsList.isNotEmpty
            // avoiding Error of calling '.length' on []
            ? topicImagePathsList.asMap().containsKey(_topicId)
            : false;
        if (!_pathExists) {
          // topicImagePathsList is empty or not ready at this point. hence, again generate filePath manually;
          _folderPath = appDocDir.path + "/" + "images" + "/";
          _fileNameRegExp = RegExp(r"\w*\d*\.\w*");
          _fileName = _fileNameRegExp.stringMatch(_imageUrl);
          _filePath = _folderPath + _fileName;
        } else {
          // topicImagePathsList is ready or contains path
          _filePath = topicImagePathsList[_topicId];
        }
        File _file = File(_filePath);
        _file.writeAsBytes(response.data).then((file) {
          if (mounted) {
            setState(() {
              _filePath = file.path;
              _fileExists = File(_filePath).existsSync(); // state
            });
          }
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _topic = widget.topic;
    _topicId = _topic.id - 1; // topic index = topicId - 1
    _imageUrl = _topic.imageUrl;
    _pathExists = topicImagePathsList.isNotEmpty
        // avoiding Error of calling '.length' on []
        ? topicImagePathsList.asMap().containsKey(_topicId)
        : false;
    if (!_pathExists) {
      // topicImagePathsList is empty or not ready at this point. hence, again generate filePath manually;
      _folderPath = appDocDir.path + "/" + "images" + "/";
      _fileNameRegExp = RegExp(r"\w*\d*\.\w*");
      _fileName = _fileNameRegExp.stringMatch(_imageUrl);
      _filePath = _folderPath + _fileName;
    } else {
      // topicImagePathsList is ready or contains path
      _filePath = topicImagePathsList[_topicId];
    }
    // _fileExists = File(_filePath).existsSync();

    print("Memeory leaks? build _TopicImageState");

    return _fileExists
        ? FadeInImage(
            // load image from file
            placeholder: MemoryImage(kTransparentImage),
            image: FileImage(File(_filePath)),
            height: widget.imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.memory(
            kTransparentImage,
            height: widget.imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }
}
