import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../components/comment_sheet.dart';
import '../../components/editor_sheet.dart';
import '../../components/feed_actions.dart';
import '../../components/feed_card.dart';
import '../../components/header.dart';
import '../../components/share_sheet.dart';
import '../../controllers/comment_controller.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../controllers/feed_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import '../../widgets/loader.dart';

class FeedScreen extends StatelessWidget {
// class FeedScreen extends GetView<FeedController> {
  const FeedScreen({Key? key}) : super(key: key);

  FeedController get controller => Get.find<FeedController>();

  bool get _loading => controller.loading();
  bool get _fetching => controller.fetching();
  List<Feed?> get _feeds => controller.feeds;
  int get _currIndex => controller.currIndex.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            title: "Live Feed",
            showLives: true,
            handleSearch: controller.handleNavigation,
          ),
          // const SizedBox(height: 20,),
          Obx(() =>
          (_loading) ?
          const Loader() :
          Flexible(
              child: RefreshIndicator(
                onRefresh: controller.getData,
                child: (!_loading && _feeds.isEmpty) ?
                ListView(
                  shrinkWrap: true,
                  // physics: const BouncingScrollPhysics(),
                  children: [
                    SvgPicture.asset(Assets.iconsNoFeeds, height: 300),
                    const Text("No Feeds!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Larsseit',
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ) :

                ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemBuilder: (context, index) => FeedCard(
                        index: index,
                        isInView: false,
                        post: _feeds.elementAt(index),
                        onDownload: controller.handleDownload,
                        handleNavigate: () => onTap(index),
                        // controller: controller.videos.firstWhereOrNull((v) => v?.dataSource.substring(50) == _feeds.elementAt(index)?.feedPath),
                        actions: Obx(() => FeedActions(
                          index: index,
                          loader: _fetching && _currIndex == index,
                          liked: _feeds.elementAt(index)?.postLiked == "Liked",
                          commentsCount: _feeds.elementAt(index)?.postComments ?? 0,
                          likeCount: _feeds.elementAt(index)?.postLikes ?? 0,
                          onLikeTap: handleLikeTap,
                          onCommentTap: () =>  handleComment(_feeds.elementAt(index)!.feedId!),
                          onShareTap: () => handleShare(_feeds.elementAt(index)!),
                        )),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemCount: _feeds.length
                )
              )
          )),
        ],
      ),

     floatingActionButton: FloatingActionButton(
       onPressed: openEditorSheet,
       child: const Icon(FontAwesome5Solid.brush),
     )
    );
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

  // GOTO PROFILE
  void onTap(int index) {
    User u = User(userId: _feeds.elementAt(index)?.userId,);
    controller.gotoProfile(u);
  }

  // ON LIKE TAP
  handleLikeTap(int index) {
    if(_feeds.elementAt(index)?.feedId != null) {
      controller.handleLike(index, _feeds.elementAt(index)!.feedId!);
    }
  }

  // OPEN EDITOR SHEET
  openEditorSheet() {
     Get.bottomSheet(
        const EditorSheet(),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
        enableDrag: true,
        persistent: true,
        ignoreSafeArea: false
    );
  }
}