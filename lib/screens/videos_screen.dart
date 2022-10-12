import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../components/comment_sheet.dart';
import '../components/feed_actions.dart';
import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/share_sheet.dart';
import '../components/title_row.dart';
import '../components/todays_picks.dart';
import '../components/trending_card.dart';
import '../controllers/comment_controller.dart';
import '../controllers/feed_controller.dart';
import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../widgets/loader.dart';
import '../widgets/text_widget.dart';

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
  List<Feed?> get _videos => _feeds.where((v) => v?.feedType == "Video").toList();
  List<Feed?> get _trending => _feeds.where((v) => v?.feedType == "Video").toList();
  List<Feed?> get _today => _feeds.where((v) => v?.feedType == "Video" && _checkDateIsToday(v!.feedDate!)).toList();

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

            Obx(() =>
            (_loading) ?
            const Loader() :
            Expanded(
                child: TabBarView(
                  children: [
                    _view(_videos, 0), // ALL VIDEOS
                    _view(_trending, 1), // TRENDING VIDEOS
                    _view(_today, 1), // TODAY'S VIDEOS
                    // SvgPicture.asset(Assets.searchUsers), // TODAY'S VIDEOS
                  ],
                )
            ),),
          ],
        ),
      ),
    );
  }

  Widget _view(List<Feed?> items, int tab) {
    return RefreshIndicator(
      onRefresh: _controller.getFeeds,
      child: (!_loading && items.isEmpty) ?
      ListView(
        // shrinkWrap: true,
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
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          builder: (context, index) => InViewNotifierWidget(
            id: '$index',
            builder: (BuildContext context, bool isInView, Widget? child) => Padding(
              padding: const EdgeInsets.only(top: 20),
              child:Obx(() => FeedCard(
                index: index,
                isInView: isInView,
                post: items.elementAt(index),
                onDownload: _controller.handleDownload,
                handleNavigate: () => onTap(index, items.elementAt(index)!),
                controller: _controller.videos.firstWhereOrNull((v) => v?.dataSource.substring(50) == items.elementAt(index)?.feedPath),
                actions: FeedActions(
                  index: index,
                  loader: _fetching && _currIndex == index && _currTab == tab,
                  liked: items.elementAt(index)?.postLiked == "Liked",
                  commentsCount: items.elementAt(index)?.postComments ?? 0,
                  likeCount: items.elementAt(index)?.postLikes ?? 0,
                  onLikeTap: (value) => handleLikeTap(index, items.elementAt(index)!, tab),
                  onCommentTap: () =>   handleComment(index, items.elementAt(index)!),
                  onShareTap: () => handleShare(items.elementAt(index)!),
                ),
              ),
            ),
          )),
          itemCount: items.length
      ),
    );
  }

  // COMMENT SHEET
  handleComment(int index, Feed item) async {
    Get.create(() => CommentController(feedId: item.feedId.toString()));
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
