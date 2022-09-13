import 'package:flutter/material.dart';
import 'package:musedme/components/feed_card.dart';
import 'package:musedme/screens/feed_screen.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../components/header.dart';
import '../components/todays_picks.dart';
import '../components/trending_card.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  List<String> tabs = [
    "All videos",
    "Playlists",
    "Trending",
    "What's new?"
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            const Header(title: "Media videos"),
            const SizedBox(height: 20,),
            TabBar(
              labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.black,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                tabs: List.generate(tabs.length, (index) => Tab(
                  text: tabs.elementAt(index),
                ))
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: const [
                  TrendingCard(),

                  SizedBox(height: 20,),

                  FeedCard(),

                  ListTile(
                    title: TextWidget("Today's Picks", weight: FontWeight.w800, size: 20),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: TextWidget("Selected for you based on your recent activity",
                        color: AppColors.lightGrey,
                        size: 14,
                      ),
                    ),
                  ),

                  TodayPicks(),
                ],
              ),
            ),

            // Expanded(
            //     child: ListView.separated(
            //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //         itemBuilder: (context, index) => const FeedCard(),
            //         separatorBuilder: (context, index) => const SizedBox(height: 20),
            //         itemCount: 4
            //     )
            // ),
          ],
        ),
      ),
    );
  }
}
