import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../components/feed_card.dart';
import '../components/header.dart';
import '../models/feed.dart';
import '../controllers/feed_controller.dart';
import '../widgets/loader.dart';
import 'search_users_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  FeedController get _controller => Get.find<FeedController>();

  bool get _loading => _controller.loading();
  List<Feed?> get _feeds => _controller.feeds;

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
          Expanded(
              child: RefreshIndicator(
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
                    itemCount: _feeds.length
                ),
              )
          ),),
        ],
      ),
    );
  }
}
