import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/app_colors.dart';
import 'loader.dart';

class ThumbnailWidget extends StatefulWidget {
  final String path;
  const ThumbnailWidget(this.path, {Key? key}) : super(key: key);

  @override
  State<ThumbnailWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  String? path;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return path == null ?
    const Center(child: Loader()) :
    Image.file(
      File(path ?? ""),
      fit: BoxFit.cover, height: double.infinity, width: double.infinity,);
  }

  Future<void> genThumbnail() async {
    String? fileName = await VideoThumbnail.thumbnailFile(video: widget.path, thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 50,
    );
    setState(() {
      path = fileName;
    });
  }
}
