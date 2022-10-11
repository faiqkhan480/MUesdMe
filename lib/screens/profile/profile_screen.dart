import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/comment_sheet.dart';
import '../../components/header.dart';
import '../../components/share_sheet.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import 'profile_body.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  User? get _user => controller.user.value;

  double get _toolbarHeight => controller.toolbarHeight();
  bool get _loading => controller.loading();
  List<Feed?> get _feeds => controller.feeds;

  bool get _fetching => controller.fetching();
  int get _currIndex => controller.currIndex.value;
  int get _currTab => controller.currTab.value;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Obx(() => Stack(
          children: [
            Container(
              decoration: (!_loading || _user?.userId != null) ? const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange,
                      AppColors.primaryColor,
                      AppColors.pinkColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )
              ) : null,
              height: 300,
              width: double.infinity,
            ),
            (_loading && _user == null) ?
            Center(child: Lottie.asset(Assets.loader)):
                RefreshIndicator(
                  onRefresh: controller.getData,
                  child: ProfileBody(
                    onRefresh: controller.getData,
                    loader: _loading,
                    scrollController: controller.scroll(),
                    user: _user,
                    feeds: _feeds,
                    toolbarHeight: _toolbarHeight,
                    fetchingFeeds: controller.feedsLoading(),
                    currIndex: _currIndex,
                    currTab: _currTab,
                    fetching: _fetching,
                    likeTap: handleLikeTap,
                    onShareTap: handleShare,
                    onCommentTap: handleComment,
                  ),
                    ),

            Header(
                title: "Profile",
                isProfile: true,
                showShadow: false,
                action: controller.handleClick,
                height: 108,
              ),
          ],
        )),
      ),
    );
  }

  // ON LIKE TAP
  handleLikeTap(int index, Feed item, int tab) {
    if(item.feedId != null) {
      controller.handleLike(index, item.feedId!, currentTab: tab);
    }
  }

  // COMMENT SHEET
  handleComment(int feedId) async {
    Get.create(() => CommentController(feedId: feedId.toString()));
    await Get.bottomSheet(
        const CommentSheet(),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
        enableDrag: true,
        persistent: true,
        ignoreSafeArea: false
    );
    Get.delete<CommentController>(force: true);
  }

  // SHARE SHEET
  handleShare(Feed feed) async {
    await Get.bottomSheet(
        ShareSheet(feed: feed),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
        enableDrag: true,
        persistent: true,
        ignoreSafeArea: false
    );
  }
}
