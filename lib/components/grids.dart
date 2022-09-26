import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/file_model.dart';

class Grids extends StatelessWidget {
  // final bool images;
  final List? items;
  final Function(int)? onTap;
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
              onTap: () => onTap!(index),
              child: Image.file(
                File(items?.elementAt(index)),
                fit: BoxFit.cover,
              ),
            );
          }
          else {
            debugPrint("LOP::::::::${controllers?.elementAt(index)}");
            return GestureDetector(
                onTap: () => onTap!(index),
                child:  Center(
                  child: AspectRatio(
                      aspectRatio: controllers!.elementAt(index).value.aspectRatio,
                      child: VideoPlayer(controllers!.elementAt(index))
                  ),
                )
            );
            // late VideoPlayerController _controller;
            // _controller =
            // VideoPlayerController.file(File(items?.elementAt(index).path!))..initialize().then((value) {
            //   return
            // });
          }
          // return const SizedBox.shrink();
        },
        itemCount: items?.length ?? 0);
  }
}
