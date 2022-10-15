import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../components/comment_sheet.dart';
import '../components/feed_actions.dart';
import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/share_sheet.dart';
import '../controllers/comment_controller.dart';
import '../controllers/feed_controller.dart';
import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../widgets/loader.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VideosScreen> createState() => _VideosScreenState();
// }

// class _VideosScreenState extends State<VideosScreen> {

  FeedController get _controller => Get.find<FeedController>();

  bool get _loading => _controller.loading();
  bool get _fetching => _controller.fetching();
  int get _currIndex => _controller.currIndex.value;
  int get _currTab => _controller.currTab.value;
  List<Feed?> get _feeds => _controller.feeds;
  RxList<Feed?> get _videos => _feeds.where((v) => v?.feedType == "Video").toList().obs;
  RxList<Feed?> get _trending => _feeds.where((v) => v?.feedType == "Video" && v!.postLikes! > 0).toList().obs;
  RxList<Feed?> get _today => _feeds.where((v) => v?.feedType == "Video" && _checkDateIsToday(v!.feedDate!)).toList().obs;

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "All videos",
      // "Playlists",
      "Trending",
      "What's new?"
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Header(title: "Media videos", handleSearch: _controller.handleNavigation),
            const SizedBox(height: 20,),
            TabBar(
              labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.black,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                tabs: List.generate(tabs.length, (index) => Tab(
                  text: tabs.elementAt(index),
                ))
            ),

            Obx(_body),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if(_trending.isNotEmpty) {
      _trending.sort((a, b) => a!.postLikes!.compareTo(b!.postLikes!));
    }
    return (_loading) ?
    const Loader() :
    Flexible(
        child: TabBarView(
          children: [
            _view(_videos, 0), // ALL VIDEOS
            _view(_trending, 1), // TRENDING VIDEOS
            _view(_today, 1), // TODAY'S VIDEOS
            // SvgPicture.asset(Assets.searchUsers), // TODAY'S VIDEOS
          ],
        )
    );
  }

  Widget _view(RxList<Feed?> items, int tab) {
    if(!_loading && items.isEmpty) {
      return SvgPicture.asset(Assets.searchUsers, height: 300);
    //     Column(
    //       children: [
    //         const Text("No Feeds!",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: Colors.black,
    //             fontSize: 20,
    //             fontFamily: 'Larsseit',
    //             fontWeight: FontWeight.w500,
    //           ),
    //         ),
    //   ],
    // );
    }
    return RefreshIndicator(
      onRefresh: _controller.getFeeds,
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemBuilder: (context, index) => Obx(() => FeedCard(
            index: index,
            isInView: true,
            post: items.elementAt(index),
            onDownload: _controller.handleDownload,
            handleNavigate: () => onTap(index, items.elementAt(index)!),
            // controller: _controller.videos.firstWhereOrNull((v) => v?.dataSource.substring(50) == items.elementAt(index)?.feedPath),
            actions: Obx(() => FeedActions(
              index: index,
              loader: _fetching && _currIndex == index && _currTab == tab,
              liked: items.elementAt(index)?.postLiked == "Liked",
              commentsCount: items.elementAt(index)?.postComments ?? 0,
              likeCount: items.elementAt(index)?.postLikes ?? 0,
              onLikeTap: (value) => handleLikeTap(index, items.elementAt(index)!, tab),
              onCommentTap: () =>   handleComment(index, items.elementAt(index)!),
              onShareTap: () => handleShare(items.elementAt(index)!),
            )),
          ),),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: items.length
      ),
    );
  }

  // COMMENT SHEET
  handleComment(int index, Feed item) async {
    Get.create(() => CommentController(feedId: item.feedId.toString(),  action: _controller.updateCommentCount));
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
    Get.bottomSheet(
        ShareSheet(feed: feed),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
        enableDrag: true,
        persistent: true,
        ignoreSafeArea: false
    );
  }

  // GOTO PROFILE
  void onTap(int index, Feed item) {
    User u = User(userId: item.userId,);
    _controller.gotoProfile(u);
  }

  // ON LIKE TAP
  handleLikeTap(int index, Feed item, int tab) {
    if(item.feedId != null) {
      _controller.handleLike(index, item.feedId!, currentTab: tab);
    }
  }

  bool _checkDateIsToday(DateTime dateToCheck) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);


    // final dateToCheck = ...
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if(aDate == today) {
      return true;
    }
    else {
      return false;
    }
    // else if(aDate == yesterday) {
    // ...
    // } else(aDate == tomorrow) {
    // ...
    // }
  }
}
