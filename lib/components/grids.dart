import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/file_model.dart';

class Grids extends StatelessWidget {
  // final bool images;
  final List? items;
  final Function(int, {String? path})? onTap;
  final List<VideoPlayerController>? controllers;
  const Grids({Key? key, this.items, this.onTap, this.controllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4),
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10),
        itemBuilder: (context, index) {
          // var file = imagePicker ? selectedImage!.files!.elementAt(i) : selectedVideo!.files!.elementAt(i);
          if(items?.elementAt(index) is String) {
            return GestureDetector(
              onTap: () => onTap!(index, path: items?.elementAt(index)),
              child: Image.file(
                File(items?.elementAt(index)),
                fit: BoxFit.cover,
              ),
            );
          }
          else {
            return FutureBuilder<String?>(
              future: genThumbnail(items!.elementAt(index).path),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                 return GestureDetector(
                      onTap: () => onTap!(index, path: items!.elementAt(index).path),
                      child:  Image.file(
                        File(snapshot.data ?? ""),
                        fit: BoxFit.cover,
                      ),
                  );
                }
                else if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: Text(
                      "Error:\n${snapshot.error.toString()}",
                    ),
                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
                // return GestureDetector(
                //     onTap: () => onTap!(index),
                //     child:  Center(
                //       child: AspectRatio(
                //           aspectRatio: controllers!.elementAt(index).value.aspectRatio,
                //           child: VideoPlayer(controllers!.elementAt(index))
                //       ),
                //     )
                // );
              }
            );
          }
          // return const SizedBox.shrink();
        },
        itemCount: items?.length ?? 0);
  }

  Future<String?> genThumbnail(String path) async {
    String? fileName = await VideoThumbnail.thumbnailFile(video: path, thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 50,
    );
    return fileName;
  }
}
