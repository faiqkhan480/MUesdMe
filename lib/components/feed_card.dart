import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/comment_controller.dart';
import '../controllers/feed_controller.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/image_widget.dart';
import '../widgets/text_widget.dart';
import '../widgets/video_widget.dart';

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

  FeedController get _controller => Get.find<FeedController>();

  @override
  Widget build(BuildContext context) {
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
                Obx(() => VideoWidget(
                    url: "${Constants.FEEDS_URL}${post?.feedPath}",
                    controller: _controller.videos.first!,
                    // controller: _controller.videos.f,
                    play: isInView
                )) :
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
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: TextWidget("There’s nothing better drive on Golden Gate Bridge the wide strait connecting. #Golden #Bridge more"),
          // ),
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
                  onPressed: handleComment,
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

  handleOption(String item) {
    if(item == "1") {
      _controller.handleDownload(post?.feedPath ?? "",  post?.feedType == "Video");
    }
  }

  // SEARCH SHEET
  handleComment() {
    Get.create(() => CommentController(feedId: 0.toString()));
    Get.bottomSheet(
        const CommentSheet(),
        // isDismissible: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
        enableDrag: true,
        // isScrollControlled: true,
        persistent: true,
        ignoreSafeArea: false
    );
  }
}

class CommentSheet extends GetWidget<CommentController> {
  const CommentSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ListView.builder(
                itemBuilder: (context, index) => Row(
                  children: [
                    _imageView(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F1FE),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const  [
                                TextWidget(
                                  "profileName",
                                  weight: FontWeight.w800,
                                ),
                                TextWidget(
                                  "postComment",
                                  // weight: FontWeight.bold,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // separatorBuilder: separatorBuilder,
                itemCount: 2
            )),
            const SizedBox(height: 20),

            TextFormField(
              // controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.send,color: Theme.of(context).primaryColor,),
                  onPressed: () => null,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _removable(Widget child) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // setState(() {
            //   image = null;
            //   // widget?.onImageRemoved();
            // });
          },
        )
      ],
    );
  }

  Widget _imageView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          Constants.dummyImage,
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}

