import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

          // CommentBox(
          //   image: Image.network(
          //     Constants.dummyImage,
          //     height: 40,
          //     width: 40,
          //   ),
          //   controller: TextEditingController(),
          //   onImageRemoved: (){
          //     //on image removed
          //   },
          //   onSend: (){
          //     //on send button pressed
          //   },
          // ),
        ],
      ),
    );
  }
}

class CommentBox extends StatefulWidget {
  final Widget? image;
  final TextEditingController? controller;
  final BorderRadius? inputRadius;
  final Function()? onSend,onImageRemoved;

  const CommentBox({Key? key, this.image, this.controller, this.inputRadius, this.onSend , this.onImageRemoved }) : super(key: key);

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  Widget? image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Colors.grey[300],
          thickness: 1,
        ),
        const SizedBox(height: 20),
        // if (image != null)
        //   _removable(
        //     context,
        //     _imageView(context),
        //   ),
        if(widget.controller!=null) TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.send,color: Theme.of(context).primaryColor,),
              onPressed: widget.onSend,
            ),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: widget.inputRadius ?? BorderRadius.circular(32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _removable(BuildContext context, Widget child) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              image = null;
              // widget?.onImageRemoved();
            });
          },
        )
      ],
    );
  }

  Widget _imageView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: image,
      ),
    );
  }
}

