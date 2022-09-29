import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/utils/assets.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/utils/constants.dart';
import 'package:video_player/video_player.dart';

import '../models/feed.dart';
import '../widgets/button_widget.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/image_widget.dart';
import '../widgets/text_widget.dart';

class FeedCard extends StatelessWidget {
  final double? horizontalSpace;
  final int index;
  final bool isInView;
  final Feed? post;
  const FeedCard({
    Key? key,
    this.horizontalSpace,
    required this.index,
    this.isInView = false,
    this.post
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4
          )]
      ),
      margin: EdgeInsets.symmetric(horizontal: horizontalSpace ?? 0),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Badge(
              badgeColor: AppColors.successColor,
              position: BadgePosition.topEnd(top: -1, end: 4),
              elevation: 0,
              borderSide: const BorderSide(color: Colors.white, width: .7),
              // child: ImageWidget(
              //   url: "${Constants.IMAGE_URL}${post?.profilePic}",
              //   borderRadius: 100,
              //   height: 80,
              // ),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  backgroundImage: NetworkImage(post?.profilePic != null ? "${Constants.IMAGE_URL}${post?.profilePic}" : Constants.dummyImage,
                  )
              ),
            ),
            title: TextWidget(post?.fullName ??  "", weight: FontWeight.w800),
            subtitle: TextWidget("@${post?.userName}", size: 12, weight: FontWeight.w500, color: AppColors.lightGrey),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                TextWidget("3 min ago", color: AppColors.lightGrey, size: 12),
                SizedBox(width: 10,),
                Icon(Icons.more_horiz_rounded, color: AppColors.lightGrey)
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Badge(
                showBadge: post?.postViews != null && post!.postViews! > 0,
                shape: BadgeShape.square,
                // badgeColor: Colors.black26,
                borderRadius: BorderRadius.circular(8),
                position: BadgePosition.topEnd(top: 12, end: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                badgeContent: Row(
                  children: [
                    SvgPicture.asset(Assets.iconsEye),
                    const SizedBox(width: 5,),
                    TextWidget("${post?.postViews} views", color: Colors.white, weight: FontWeight.w300,),
                  ],
                ),
                elevation: 0,
                child: post?.feedType == "Video" ?
                VideoWidget(
                    url: "${Constants.FEEDS_URL}${post?.feedPath}",
                    play: isInView
                ) :
                ImageWidget(
                  url: "${Constants.FEEDS_URL}${post?.feedPath}",
                  height: 250,
                ),
              ),

              if(post?.feedType == "Video")
                const GlassMorphism(
                  start: 0.3,
                  end: 0.3,
                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 60),
                )
            ],
          ),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextWidget("There’s nothing better drive on Golden Gate Bridge the wide strait connecting. #Golden #Bridge more"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 8.0),
            child: Row(
              children:  [
                ButtonWidget(
                  onPressed: () => null,
                  text: "${post?.postLikes ?? ""}",
                  icon: Assets.iconsHeart,
                ),
                ButtonWidget(
                  onPressed: () => null,
                  text: "${post?.postComments ?? ""} comments",
                  icon: Assets.iconsComment,
                ),
                const Spacer(),
                ButtonWidget(
                  onPressed: () => null,
                  text: "Share",
                  textColor: AppColors.primaryColor,
                  icon: Assets.iconsShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;
  final bool play;

  const VideoWidget({Key? key, required this.url, required this.play})
      : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late CachedVideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });

    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CachedVideoPlayer(_controller)),
              ));
        } else {
          return Lottie.asset(Assets.loader);
        }
      },
    );
  }
}
