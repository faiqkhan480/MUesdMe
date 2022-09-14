import 'package:flutter/material.dart';
import 'package:musedme/components/feed_card.dart';
import 'package:musedme/screens/feed_screen.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/utils/constants.dart';
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
            Header(title: "Media videos", action: () => null,),
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
                children: [
                  const FeedCard(horizontalSpace: 20, isVideo: true),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextWidget("Trending videos", size: 17, color: AppColors.primaryColor),
                        TextButton(
                            onPressed: () => null,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.lightGrey,
                              textStyle: const TextStyle(
                                fontFamily: Constants.fontFamily,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                                decorationThickness: 2
                            )
                          ),
                            child: const Text("Show all"),
                        ),
                      ],
                    ),
                  ),

                  const TrendingCard(horizontalSpace: 20),

                  const SizedBox(height: 20,),

                  const TrendingCard(horizontalSpace: 20),

                  const SizedBox(height: 20,),

                  const FeedCard(horizontalSpace: 20, isVideo: true),

                  const SizedBox(height: 20,),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
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

                  const SizedBox(height: 20,),

                  const TodayPicks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
