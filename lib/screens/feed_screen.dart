import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lottie/lottie.dart';

import '../components/feed_card.dart';
import '../components/header.dart';
import '../models/feed.dart';
import '../services/api_service.dart';
import '../utils/assets.dart';
import '../utils/di_setup.dart';
import 'search_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ApiService _service = getIt<ApiService>();

  List<Feed?> feeds = [];

  bool loader = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeeds();
  }

  Future<void> getFeeds() async {
    try{
      List res = await _service.fetchPosts();
      setState(() {
        feeds = res as List<Feed?>;
        loader = false;
      });
    }
    catch(e) {
      setState(() {
        feeds = [];
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: "Live Feed", showLives: true, handleSearch: handleNavigation),
          const SizedBox(height: 20,),
          if(loader)
            Lottie.asset(Assets.loader)
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: getFeeds,
                child: InViewNotifierList(
                    isInViewPortCondition:
                        (double deltaTop, double deltaBottom, double viewPortDimension) {
                      return deltaTop < (0.5 * viewPortDimension) &&
                          deltaBottom > (0.5 * viewPortDimension);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    builder: (context, index) => FeedCard(index: index, post: feeds.elementAt(index)),
                    // separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemCount: feeds.length
                ),
              )
          ),
        ],
      ),
    );
  }

  handleNavigation() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => const SearchScreen()));
  }
}
