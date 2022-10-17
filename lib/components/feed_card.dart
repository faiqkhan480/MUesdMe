import 'package:badges/badges.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/agora_controller.dart';
import '../controllers/feed_controller.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/image_widget.dart';
import '../widgets/shadowed_box.dart';
import '../widgets/text_widget.dart';

class FeedCard extends StatelessWidget {
  final double? horizontalSpace;
  final int index;
  final bool isInView;
  final Feed? post;
  final Widget? actions;
  final Function(String, bool) onDownload;
  final VoidCallback? handleNavigate;
  // final CachedVideoPlayerController? controller;
  const FeedCard({
    Key? key,
    this.horizontalSpace,
    required this.index,
    this.isInView = false,
    this.post,
    this.actions,
    this.handleNavigate,
    // this.controller,
    required this.onDownload
  }) : super(key: key);

  FeedController get _feedController => Get.find<FeedController>();
  AgoraController get _agora => Get.find<AgoraController>();
  @override
  Widget build(BuildContext context) {
    bool isShared = post?.shareUser != null && post?.shareUser?.userId != 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(
              color: AppColors.grayScale,
              blurRadius: 4
          )]
      ),
      margin: EdgeInsets.symmetric(horizontal: horizontalSpace ?? 0),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<bool>(
            stream: _agora.checkStatus(post!.userId.toString()),
            initialData: post?.userId == _agora.currentUser?.userId,
            builder: (context, snapshot) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: Badge(
                  badgeColor: (snapshot.data == true) || (post?.userId == _agora.currentUser?.userId) ?
                  AppColors.successColor :
                  AppColors.lightGrey,
                  position: BadgePosition.topEnd(top: -1, end: 4),
                  elevation: 0,
                  borderSide: const BorderSide(color: Colors.white, width: .7),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    backgroundImage: NetworkImage(
                      post?.profilePic != null && post!.profilePic!.isNotEmpty ?
                      "${Constants.IMAGE_URL}${post?.profilePic}" :
                      Constants.dummyImage,
                    ),),
                ),
                title: GestureDetector(
                    onTap: handleNavigate,
                    child: TextWidget(post?.fullName ??  "", weight: FontWeight.w800)),
                subtitle: TextWidget("@${post?.userName}", size: 12, weight: FontWeight.w500, color: AppColors.lightGrey),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    TextWidget(post?.feedDate != null ? timeago.format(post!.feedDate!.toLocal()) : "", color: AppColors.lightGrey, size: 12),
                    const SizedBox(width: 10,),
                    PopupMenuButton<String>(
                        padding: const EdgeInsets.only(left: 10, right: 0),
                        onSelected: handleOption,
                        icon: const Icon(Icons.more_horiz_rounded, color: AppColors.lightGrey,),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          if(post?.feedType == "Video")
                            const PopupMenuItem<String>(
                            value: "0",
                            child: Text('Add to watch later'),
                          ),
                          const PopupMenuItem<String>(
                            value: "1",
                            child: Text("Download"),
                          ),
                        ]),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10,),
          ShadowedBox(
            shadow: isShared,
            padding: EdgeInsets.all(isShared ? 10 : 0),
            child: Stack(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(isShared)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          leading: Badge(
                            badgeColor: AppColors.lightGrey,
                            position: BadgePosition.topEnd(top: -1, end: 4),
                            elevation: 0,
                            borderSide: const BorderSide(color: Colors.white, width: .7),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              backgroundImage: NetworkImage(
                                post?.shareUser?.profilePic != null && post!.shareUser!.profilePic!.isNotEmpty ?
                                "${Constants.IMAGE_URL}${post?.shareUser?.profilePic}" :
                                Constants.dummyImage,
                              ),),
                          ),
                          title: GestureDetector(
                              onTap: handleNavigate,
                              child: TextWidget(post?.shareUser?.fullName ??  "", weight: FontWeight.w800)),
                          subtitle: TextWidget("@${post?.shareUser?.userName}", size: 12, weight: FontWeight.w500, color: AppColors.lightGrey),
                        ),

                      post?.feedType == "Video" ?
                      _video() :
                      ImageWidget(
                        url: "${Constants.FEEDS_URL}${post?.feedPath}",
                        height: 250,
                      ),
                    ],
                  ),
                ),

                // if(post?.feedType == "Video")
                //   const GlassMorphism(
                //     start: 0.3,
                //     end: 0.3,
                //     child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 60),
                //   )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: TextWidget("There’s nothing better drive on Golden Gate Bridge the wide strait connecting. #Golden #Bridge more"),
          // ),

          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 8.0),
            child: actions,
          )
        ],
      ),
    );
  }

  Widget _video() {
    return SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: BetterPlayerListVideoPlayer(
              BetterPlayerDataSource(
                BetterPlayerDataSourceType.network,
                "${Constants.FEEDS_URL}${post?.feedPath}",
                notificationConfiguration: BetterPlayerNotificationConfiguration(
                    showNotification: false,
                    title: post?.userName ?? "",
                    author: "Test",
                ),
                bufferingConfiguration: const BetterPlayerBufferingConfiguration(
                    minBufferMs: 2000,
                    maxBufferMs: 10000,
                    bufferForPlaybackMs: 1000,
                    bufferForPlaybackAfterRebufferMs: 2000),
              ),
              configuration: BetterPlayerConfiguration(
                autoDispose: false,
                  looping: true,
                  fit: BoxFit.cover,
                  autoPlay: false,
                  aspectRatio: 1,
                  eventListener: (p0) {
                    if(p0.betterPlayerEventType == BetterPlayerEventType.setVolume) {
                      _feedController.betterCtrl;
                    }
                  },
                  // handleLifecycle: true,
                controlsConfiguration: const BetterPlayerControlsConfiguration(
                    enableFullscreen: false,
                    showControlsOnInitialize: true,
                    enablePlaybackSpeed: false,
                    enableProgressBar: false,
                    enableOverflowMenu: false,
                    enableProgressText: false,
                    enablePip: false,
                    enableSkips: false,
                    // loadingWidget: Loader(),
                    controlBarColor: Colors.transparent,
                    playIcon: FontAwesome5Solid.play_circle,
                    pauseIcon: FontAwesome5Solid.pause_circle,
                    muteIcon: FontAwesome5Solid.volume_up,
                    unMuteIcon: FontAwesome5Solid.volume_mute,
                    enablePlayPause: false
                )
              ),
              //key: Key(videoListData.hashCode.toString()),
              playFraction: 0.8,
              betterPlayerListVideoPlayerController: _feedController.betterCtrl,
            ),
          ),
        )
    );
  }

  handleOption(String item) {
    if(item == "1") {
      onDownload(post?.feedPath ?? "",  post?.feedType == "Video");
    }
  }
}