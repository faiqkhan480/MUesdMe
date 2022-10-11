import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../components/comment_sheet.dart';
import '../components/feed_actions.dart';
import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/share_sheet.dart';
import '../controllers/comment_controller.dart';
import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../controllers/feed_controller.dart';
import '../utils/assets.dart';
import '../widgets/loader.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  FeedController get _controller => Get.find<FeedController>();

  bool get _loading => _controller.loading();
  bool get _fetching => _controller.fetching();
  List<Feed?> get _feeds => _controller.feeds;
  int get _currIndex => _controller.currIndex.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: "Live Feed", showLives: true, handleSearch: _controller.handleNavigation),
          // const SizedBox(height: 20,),
          Obx(() =>
          (_loading) ?
          const Loader() :
          Flexible(
              child: RefreshIndicator(
                onRefresh: _controller.getFeeds,
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
                InViewNotifierList(
                    isInViewPortCondition:
                        (double deltaTop, double deltaBottom, double viewPortDimension) {
                      return deltaTop < (0.5 * viewPortDimension) &&
                          deltaBottom > (0.5 * viewPortDimension);
                    },
                    // physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    builder: (context, index) => InViewNotifierWidget(
                      id: '$index',
                      builder: (BuildContext context, bool isInView, Widget? child) => Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: FeedCard(
                            index: index,
                            isInView: isInView,
                            post: _feeds.elementAt(index),
                            onDownload: _controller.handleDownload,
                            handleNavigate: () => onTap(index),
                            controller: _controller.videos.firstWhereOrNull((v) => v?.dataSource.substring(50) == _feeds.elementAt(index)?.feedPath),
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
                      ),
                    ),
                    // separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemCount: _feeds.length
                ),
              )
          )),
        ],
      ),
    );
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

  // GOTO PROFILE
  void onTap(int index) {
    User u = User(userId: _feeds.elementAt(index)?.userId,);
    _controller.gotoProfile(u);
  }

  // ON LIKE TAP
  handleLikeTap(int index) {
    if(_feeds.elementAt(index)?.feedId != null) {
      _controller.handleLike(index, _feeds.elementAt(index)!.feedId!);
    }
  }
}
