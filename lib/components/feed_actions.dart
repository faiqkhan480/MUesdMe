import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../widgets/button_widget.dart';

class FeedActions extends StatelessWidget {
  const FeedActions({
    Key? key,
    required this.loader,
    this.commentsCount,
    required this.index,
    this.likeCount,
    required this.liked,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap
  }) : super(key: key);

  final int index;
  final int? likeCount;
  final int? commentsCount;
  final bool liked;
  final bool loader;
  final ValueChanged<int>? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        ButtonWidget(
          onPressed: () => onLikeTap!(index),
          text: "${likeCount ?? 0}",
          loader: loader,
          icon: liked ? Assets.iconsHeart : Assets.iconsUnlikeHeart,
        ),
        ButtonWidget(
          onPressed: onCommentTap,
          // onPressed: handleComment,
          text: "${commentsCount ?? 0} comments",
          icon: Assets.iconsComment,
        ),
        const Spacer(),
        ButtonWidget(
          onPressed: onShareTap,
          text: "Share",
          textColor: AppColors.primaryColor,
          icon: Assets.iconsShare,
        ),
      ],
    );
  }
}
