import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musedme/widgets/loader.dart';

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
  final Widget? actions;
  final List<Feed?>? feeds;
  final CachedVideoPlayerController? video;
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
    this.actions,
    this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "My Feed",
      "Images",
      "Videos"
    ];
    
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NestedScrollView(
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
                    listing(feeds ?? []),
                    listing(feeds?.where((f) => f?.feedType == "Image").toList() ?? []),
                    listing(feeds?.where((f) => f?.feedType == "Video").toList() ?? []),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listing(List<Feed?> data) {
    return
    ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemBuilder: (context, index) => FeedCard(
          horizontalSpace: 10,
          index: index,
          post: data.elementAt(index),
          onDownload: (p0, p1) => null,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: data.length
    );
  }
}