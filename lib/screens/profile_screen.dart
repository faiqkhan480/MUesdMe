import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/info_card.dart';
import '../generated/assets.dart';
import '../utils/app_colors.dart';
import '../widgets/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> tabs = [
    "My Feed",
    "Images",
    "Videos"
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            const Header(title: "Profile", isProfile: true, showShadow: false,),
            // const SizedBox(height: 20,),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 100, bottom: 0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const InfoCard(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TabBar(
                            labelColor: AppColors.primaryColor,
                            unselectedLabelColor: Colors.black,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                            tabs: List.generate(tabs.length, (index) => Tab(
                              text: tabs.elementAt(index),
                            ))
                        ),
                      ),

                      const FeedCard(horizontalSpace: 20, isVideo: true),
                      const SizedBox(height: 20,),
                      const FeedCard(horizontalSpace: 20, isVideo: true),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
