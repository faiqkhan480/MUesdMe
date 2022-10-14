// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../components/feed_actions.dart';
import '../../components/feed_card.dart';
import '../../components/info_card.dart';
import '../../controllers/feed_controller.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';


class ProfileBody extends StatelessWidget {
  final User? user;
  final bool loader;
  final bool fetchingFeeds;
  final Future Function() onRefresh;
  final Widget? button;
  final Widget? options;
  final RxList<Feed?> feeds;
  // final CachedVideoPlayerController? videoController;
  final bool fetching;
  final int currIndex;
  final int currTab;
  final bool isOnline;
  final Function(int, Feed, int) likeTap;
  final Function(int) onCommentTap;
  final Function(Feed) onShareTap;
  const ProfileBody({
    Key? key,
    this.user,
    this.loader = false,
    this.fetchingFeeds = true,
    required this.onRefresh,
    this.button,
    this.options,
    required this.feeds,
    // this.videoController,
    required this.fetching,
    required this.currIndex,
    required this.currTab,
    required this.likeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.isOnline
  }) : super(key: key);

  FeedController get _feedController => Get.find<FeedController>();

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "My Feed",
      "Images",
      "Videos"
    ];
    return NestedScrollView(

      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 200.0,
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
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
                  isOnline: isOnline,
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
              padding: const EdgeInsets.only(top: 10),
              // padding: EdgeInsets.only(top: toolbarHeight),
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
            Obx(() =>
                Flexible(
                  child: (!fetchingFeeds && feeds.isEmpty) ?
                  SvgPicture.asset(Assets.searchUsers) :
                  TabBarView(
                    children: [
                      listing(feeds, 0),
                      listing(feeds.where((f) => f?.feedType == "Image").toList().obs, 1),
                      listing(feeds.where((f) => f?.feedType == "Video").toList().obs, 2),
                    ],
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget listing(RxList<Feed?> data, int tab) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: data.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) => FeedCard(
        horizontalSpace: 10,
        index: index,
        post: data.elementAt(index),
        onDownload: _feedController.handleDownload,
        handleNavigate: () {
          User u = User(userId: data.elementAt(index)?.userId,);
          _feedController.gotoProfile(u);
        },
        // controller: videoController,
        actions: FeedActions(
          index: index,
          loader: fetching && currIndex == index && currTab == tab,
          liked: data.elementAt(index)?.postLiked == "Liked",
          commentsCount: data.elementAt(index)?.postComments ?? 0,
          likeCount: data.elementAt(index)?.postLikes ?? 0,
          onLikeTap: (value) => likeTap(index, data.elementAt(index)!, tab),
          onCommentTap: () =>  onCommentTap(data.elementAt(index)!.feedId!),
          onShareTap: () => onShareTap(data.elementAt(index)!),
        ),
      ),
    );
  }
}