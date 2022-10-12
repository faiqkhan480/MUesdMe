import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';import '../../components/comment_sheet.dart';


import '../../components/custom_header.dart';
import '../../components/share_sheet.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/user_profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../utils/assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_config.dart';
import '../../widgets/button_widget.dart';

import 'profile_body.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  const UserProfileScreen({Key? key}) : super(key: key);

  // User? get args => Get.arguments;

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
               height: 100,
               child: const CustomHeader(
                 title: "Profile",
                 buttonColor: AppColors.primaryColor,
                 showBottom: false,
                 showSave: false
             )
           ),

           Flexible(child: Obx(() => Stack(
             children: [
               Container(
                 height: 500,
                 width: double.infinity,
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
                 // child: (!_loading || _user?.userId != null) ?
                 // Align(
                 //   alignment: Alignment.topCenter,
                 //   child: Image.network(Constants.coverImage,
                 //     height: 400,
                 //     fit: BoxFit.cover,
                 //   ),
                 // ) : null,
               ),
               (_loading && _user?.userId == null) ?
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
                     options: PopupMenuButton<int>(
                         padding: const EdgeInsets.only(left: 10, right: 0),
                         onSelected: handleOption,
                         icon: const Icon(Icons.more_horiz_rounded, color: AppColors.lightGrey,),
                         itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                           const PopupMenuItem<int>(
                             value: 0,
                             child: Text('Message'),
                           ),
                           const PopupMenuItem<int>(
                             value: 1,
                             child: Text("Call"),
                           ),
                         ]
                     ),
                     button: ButtonWidget(
                       text: _user?.follow == 0 ? "Follow" : "Un Follow",
                       onPressed: controller.sendFollowReq,
                       bgColor: AppColors.primaryColor,
                       textColor: Colors.white,
                       loader: _loading,
                     ),
                     currIndex: _currIndex,
                     currTab: _currTab,
                     fetching: _fetching,
                     likeTap: handleLikeTap,
                     onShareTap: handleShare,
                     onCommentTap: handleComment,
                   )
               ),
             ],
           ))),
         ],
        ),
      ),
    );
  }

  handleOption(int item) {
    switch (item) {
      case 0:
        controller.navigateToChat();
        break;
      case 1:
        controller.navigateToCall();
        break;
    }
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
