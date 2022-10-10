import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musedme/controllers/feed_controller.dart';
import 'package:musedme/widgets/loader.dart';

import '../../components/feed_actions.dart';
import '../../components/feed_card.dart';
import '../../components/info_card.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';


class ProfileBody extends StatelessWidget {
  final User? user;
  final double toolbarHeight;
  final bool loader;
  final bool fetchingFeeds;
  final Future Function() onRefresh;
  final ScrollController? scrollController;
  final Widget? button;
  final Widget? options;
  final List<Feed?>? feeds;
  final CachedVideoPlayerController? videoController;
  final bool fetching;
  final int currIndex;
  final int currTab;
  final Function(int, Feed, int) likeTap;
  final Function(int) onCommentTap;
  final Function(Feed) onShareTap;
  const ProfileBody({
    Key? key,
    this.user,
    this.scrollController,
    this.loader = false,
    this.fetchingFeeds = true,
    required this.onRefresh,
    this.toolbarHeight = 0,
    this.button,
    this.options,
    this.feeds,
    this.videoController,
    required this.fetching,
    required this.currIndex,
    required this.currTab,
    required this.likeTap,
    required this.onCommentTap,
    required this.onShareTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "My Feed",
      "Images",
      "Videos"
    ];
    
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 300.0,
            automaticallyImplyLeading: false,
            toolbarHeight: 280,
            backgroundColor: Colors.transparent,
            forceElevated: innerBoxIsScrolled,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 180),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: InfoCard(
                  user: user,
                  button: button,
                  action: options,
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              // padding: EdgeInsets.only(top: 100),
              padding: EdgeInsets.only(top: toolbarHeight),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    TabBar(
                        labelColor: AppColors.primaryColor,
                        unselectedLabelColor: Colors.black,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                        indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(width: 2.5, color: AppColors.primaryColor),
                            insets: EdgeInsets.symmetric(horizontal: 35.0)),
                        tabs: List.generate(tabs.length, (index) => Tab(
                          text: tabs.elementAt(index),
                        ))
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: (!fetchingFeeds && feeds!.isEmpty) ?
              SvgPicture.asset(Assets.searchUsers) :
              TabBarView(
                children: [
                  listing(feeds ?? [], 0),
                  listing(feeds?.where((f) => f?.feedType == "Image").toList() ?? [], 1),
                  listing(feeds?.where((f) => f?.feedType == "Video").toList() ?? [], 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FeedController get _feedController => Get.find<FeedController>();

  Widget listing(List<Feed?> data, int tab) {
    return
    RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: data.length,
          // itemBuilder: (context, index) => FeedCard(
          //   index: index,
          //   isInView: isInView,
          //   post: _feeds.elementAt(index),
          //   onDownload: _controller.handleDownload,
          //   handleNavigate: () => onTap(index),
          //   controller: _controller.videos.firstWhereOrNull((v) => v?.dataSource.substring(50) == _feeds.elementAt(index)?.feedPath),
          //   actions: Obx(() => FeedActions(
          //     index: index,
          //     loader: _fetching && _currIndex == index,
          //     liked: _feeds.elementAt(index)?.postLiked == "Liked",
          //     commentsCount: _feeds.elementAt(index)?.postComments ?? 0,
          //     likeCount: _feeds.elementAt(index)?.postLikes ?? 0,
          //     onLikeTap: handleLikeTap,
          //     onCommentTap: () =>  handleComment(_feeds.elementAt(index)!.feedId!),
          //     onShareTap: () => handleShare(_feeds.elementAt(index)!),
          //   )),
          // ),
          itemBuilder: (context, index) => FeedCard(
            horizontalSpace: 10,
            index: index,
            post: data.elementAt(index),
            onDownload: _feedController.handleDownload,
            handleNavigate: () {
              User u = User(userId: data.elementAt(index)?.userId,);
              _feedController.gotoProfile(u);
            },
            controller: videoController,
            actions: FeedActions(
              index: index,
              loader: fetching && currIndex == index && currTab == tab,
              liked: data.elementAt(index)?.postLiked == "Liked",
              commentsCount: data.elementAt(index)?.postComments ?? 0,
              likeCount: data.elementAt(index)?.postLikes ?? 0,
              onLikeTap: (value) => likeTap(index, data.elementAt(index)!, tab),
              onCommentTap: () =>  onCommentTap(data.elementAt(index)!.feedId!),
              onShareTap: () => onShareTap(data.elementAt(index)!),
          ),),
      ),
    );
  }
}