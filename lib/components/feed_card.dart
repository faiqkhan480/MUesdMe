import 'package:badges/badges.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:musedme/widgets/shadowed_box.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/agora_controller.dart';
import '../controllers/comment_controller.dart';
import '../controllers/feed_controller.dart';
import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/image_widget.dart';
import '../widgets/text_widget.dart';
import '../widgets/video_widget.dart';
import 'comment_sheet.dart';

class FeedCard extends StatelessWidget {
  final double? horizontalSpace;
  final int index;
  final bool isInView;
  final Feed? post;
  final Widget? actions;
  final Function(String, bool) onDownload;
  final VoidCallback? handleNavigate;
  final CachedVideoPlayerController? controller;
  const FeedCard({
    Key? key,
    this.horizontalSpace,
    required this.index,
    this.isInView = false,
    this.post,
    this.actions,
    this.handleNavigate,
    this.controller,
    required this.onDownload
  }) : super(key: key);

  AgoraController get _agora => Get.find<AgoraController>();

  @override
  Widget build(BuildContext context) {
    bool isShared = post?.shareUser?.userId != 0;
    return FutureBuilder<bool>(
      future: _agora.isUserOnline(post?.userId.toString() ?? ""),
      builder: (context, AsyncSnapshot<bool> snapshot) {
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
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: Badge(
                  badgeColor: snapshot.hasData && snapshot.data! ? AppColors.successColor : AppColors.lightGrey,
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
                    TextWidget(post?.feedDate != null ?timeago.format(post!.feedDate!) : "", color: AppColors.lightGrey, size: 12),
                    const SizedBox(width: 10,),
                    PopupMenuButton<String>(
                        padding: const EdgeInsets.only(left: 10, right: 0),
                        onSelected: handleOption,
                        icon: const Icon(Icons.more_horiz_rounded, color: AppColors.lightGrey,),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                        children: [
                          if(isShared)
                            ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                            leading: Badge(
                              badgeColor: snapshot.hasData && snapshot.data! ? AppColors.successColor : AppColors.lightGrey,
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

                    if(post?.feedType == "Video")
                      const GlassMorphism(
                        start: 0.3,
                        end: 0.3,
                        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 60),
                      )
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
    );
  }

  Widget _video() {
    return VideoWidget(
        url: "${Constants.FEEDS_URL}${post?.feedPath}",
        controller: controller,
        // controller: _controller.videos.first!,
        play: isInView
    );
  }

  handleOption(String item) {
    if(item == "1") {
      onDownload(post?.feedPath ?? "",  post?.feedType == "Video");
    }
  }
}