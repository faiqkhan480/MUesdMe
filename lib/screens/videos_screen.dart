import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/title_row.dart';
import '../components/todays_picks.dart';
import '../components/trending_card.dart';
import '../controllers/feed_controller.dart';
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
  List<Feed?> get _feeds => _controller.feeds;
  List<Feed?> get _videos => _feeds.where((v) => v?.feedType == "Video").toList();
  List<Feed?> get _trending => _feeds.where((v) => v?.feedType == "Video").toList();
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
                    RefreshIndicator(
                    onRefresh: _controller.getFeeds,
                    child: InViewNotifierList(
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
                            child: FeedCard(
                                index: index,
                                isInView: isInView,
                                post: _feeds.elementAt(index)),
                          ),
                        ),
                        // separatorBuilder: (context, index) => const SizedBox(height: 20),
                        itemCount: _videos.length
                    ),
                  ),
                    // SvgPicture.asset(Assets.searchUsers),
                    RefreshIndicator(
                    onRefresh: _controller.getFeeds,
                    child: InViewNotifierList(
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
                            child: FeedCard(
                                index: index,
                                isInView: isInView,
                                post: _feeds.elementAt(index)),
                          ),
                        ),
                        // separatorBuilder: (context, index) => const SizedBox(height: 20),
                        itemCount: _videos.length
                    ),
                  ),
                    SvgPicture.asset(Assets.searchUsers),
                  ],
                )
            ),),
          ],
        ),
      ),
    );
  }

  _oldBody() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        children: const [
          FeedCard(horizontalSpace: 10, index: 0,),

          TitleRow(title: "Trending videos"),

          TrendingCard(horizontalSpace: 10),

          SizedBox(height: 20,),

          TrendingCard(horizontalSpace: 10),

          SizedBox(height: 20,),

          FeedCard(horizontalSpace: 10, index: 0),

          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
            child: ListTile(
              title: TextWidget("Today's Picks", weight: FontWeight.w800, size: 20),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: TextWidget("Selected for you based on your recent activity",
                  color: AppColors.lightGrey,
                  size: 14,
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),

          TodayPicks(),
        ],
      ),
    );
  }
}
