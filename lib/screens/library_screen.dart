import 'package:flutter/material.dart';
import 'package:musedme/components/todays_picks.dart';

import '../utils/app_colors.dart';
import '../components/category_card.dart';
import '../components/custom_header.dart';
import '../utils/assets.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomHeader(title: "Library", buttonColor: AppColors.primaryColor, showBottom: false, showSearch: true, showRecentWatches: true),

            Flexible(child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20,),

                  Container(
                  decoration: BoxDecoration(
                    color: AppColors.tabBarColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: TabBar(
                      isScrollable: false,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.black,
                      indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                      tabs: List.generate(2, (index) => Tab(text: index == 0 ? "Saved Videos" : "Liked Videos",),)
                  )
              ),

                  const SizedBox(height: 20,),

                  const TodayPicks(),

                  const SizedBox(height: 20,),

                  ...List.generate(3, (index) => CategoryCard(
                    name: index == 0 ? "History" : index == 1 ? "Watch later" : "Downloads",
                    image: index == 0 ? Assets.iconsHistory : index == 1 ? Assets.iconsWatchLater : Assets.iconsDownloadedVideos,
                    color: index == 0 ? AppColors.violet : index == 1 ? AppColors.lightGreen : null,
                    title: index == 0 ? "History of your Videos & Feed" : index == 1 ? "Your watch later marked videos" : "Your downloaded videos",
                    subtitle: index == 0 ? "Browse history of your activity" : index == 1 ? "Browse watch later feed & videos" : "Browse all downloaded Videos & Feed",
                  ),),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
