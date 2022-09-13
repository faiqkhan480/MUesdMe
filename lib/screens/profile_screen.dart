import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/screens/edit_profile_screen.dart';

import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/info_card.dart';
import '../utils/assets.dart';
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

  handleClick() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => const EditProfileScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            Header(
              title: "Profile",
              isProfile: true,
              showShadow: false,
              action: handleClick,
            ),
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
