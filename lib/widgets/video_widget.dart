import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/feed_controller.dart';
import '../utils/assets.dart';

class VideoWidget extends StatelessWidget {
// class VideoWidget extends StatefulWidget {
  final String url;
  final bool play;
  final CachedVideoPlayerController? controller;
  const VideoWidget({Key? key, required this.url, required this.play, required this.controller});
//       : super(key: key);
//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }
//
// class _VideoWidgetState extends State<VideoWidget> {
//   FeedController get _feedController => Get.find<FeedController>();
  CachedVideoPlayerController? get _video => controller;
  // late Future<void> _initializeVideoPlayerFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = widget.controller;
  // //   _controller = CachedVideoPlayerController.network(widget.url);
  // //   _initializeVideoPlayerFuture = _controller.initialize().then((_) {
  // //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  // //     setState(() {});
  // //   });
  // //
  // //   if (widget.play) {
  // //     _controller.play();
  // //     _controller.setLooping(true);
  // //   }
  // }

  // @override
  // void didUpdateWidget(VideoWidget oldWidget) {
  //   if (oldWidget.play != widget.play) {
  //     if (widget.play) {
  //       _controller.play();
  //       _controller.setLooping(true);
  //     } else {
  //       _controller.pause();
  //     }
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void dispose() {
  //   _controller.pause();
  //   // _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(
      builder: (controller) {
        if(_video == null) {
          return SizedBox(
            height: 250,
            child: Icon(Icons.video_file_outlined)
          );
        }
        return _video!.value.isInitialized ?
        SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
                aspectRatio: _video!.value.aspectRatio,
                child: CachedVideoPlayer(_video!)),
          )) :
        Lottie.asset(Assets.loader);
        },
      didUpdateWidget: (oldWidget, state) {
        if (play) {
            _video!.play();
            _video!.setLooping(true);
          } else {
            _video!.pause();
          }
      },

      // dispose: (state) {
      //   _controller.pause();
      // },
    );
    // return FutureBuilder(
    //   future: _initializeVideoPlayerFuture,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return SizedBox(
    //           height: 250,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(20),
    //             child: AspectRatio(
    //                 aspectRatio: _controller.value.aspectRatio,
    //                 child: CachedVideoPlayer(_controller)),
    //           ));
    //     } else {
    //       return Lottie.asset(Assets.loader);
    //     }
    //   },
    // );
  }
}