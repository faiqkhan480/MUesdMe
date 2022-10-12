import 'dart:io';

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
import '../../utils/style_config.dart';
import 'profile_body.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  User? get _user => controller.user.value;

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: StyleConfig.gradientBackground,
              child: Header(
                title: "Profile",
                isProfile: true,
                showShadow: false,
                action: controller.handleClick,
                height: 108,
              ),
            ),

            Flexible(child: Obx(() => Stack(
              children: [
                Container(
                  decoration: (!_loading || _user?.userId != null) ? StyleConfig.gradientBackground : null,
                  height: 300,
                  width: double.infinity,
                ),
                (_loading && _user == null) ?
                Center(child: Lottie.asset(Assets.loader)):
                RefreshIndicator(
                  // displacement: 20,
                  notificationPredicate: (notification) {
                    // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
                    if (notification is OverscrollNotification || Platform.isIOS) {
                      return notification.depth == 2;
                    }
                    return notification.depth == 0;
                 },
                  onRefresh: controller.getData,
                  child: ProfileBody(
                    onRefresh: controller.getData,
                    loader: _loading,
                    user: _user,
                    feeds: _feeds,
                    fetchingFeeds: controller.feedsLoading(),
                    currIndex: _currIndex,
                    currTab: _currTab,
                    fetching: _fetching,
                    likeTap: handleLikeTap,
                    onShareTap: handleShare,
                    onCommentTap: handleComment,
                  ),
                ),
              ],
            )))
          ],
        ),
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
    Get.create(() => CommentController(feedId: feedId.toString(), action: controller.updateCommentCount));
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
