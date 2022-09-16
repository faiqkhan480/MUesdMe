import 'package:flutter/material.dart';

import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/title_row.dart';
import '../components/todays_picks.dart';
import '../components/trending_card.dart';
import '../utils/app_colors.dart';
import '../widgets/text_widget.dart';

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
            Header(title: "Media videos",),
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                children: const [
                  FeedCard(horizontalSpace: 10, isVideo: true),

                  TitleRow(title: "Trending videos"),

                  TrendingCard(horizontalSpace: 10),

                  SizedBox(height: 20,),

                  TrendingCard(horizontalSpace: 10),

                  SizedBox(height: 20,),

                  FeedCard(horizontalSpace: 10, isVideo: true),

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
            ),
          ],
        ),
      ),
    );
  }
}
