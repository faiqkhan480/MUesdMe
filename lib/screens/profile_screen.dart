import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/screens/edit_profile_screen.dart';
import 'package:musedme/utils/constants.dart';

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

  double toolbarHeight = 35;

  ScrollController controller = ScrollController();

  handleClick() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => const EditProfileScreen(),));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      debugPrint("::::::1::::: ${controller.position.pixels}");
      if(controller.position.pixels > 540) {
        setState(() {
          toolbarHeight = 120;
        });
      } else if(controller.position.pixels < 620) {
        setState(() {
          toolbarHeight = 35;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: controller,
              slivers: [
                // USER INFO
                SliverAppBar(
                  pinned: false,
                  expandedHeight: 300.0,
                  flexibleSpace: Image.network(Constants.coverImage,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                  toolbarHeight: 400,
                  // excludeHeaderSemantics: true,
                  bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 180),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        child: const InfoCard(),
                      ),
                  ),
                ),

                // TAB BAR
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 50,
                  // collapsedHeight: 0,
                  toolbarHeight: toolbarHeight,
                  bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 0),
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
                      )
                  ),
                ),

                // FEEDS LIST
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: FeedCard(horizontalSpace: 10, index: 0),
                      );
                    },
                    childCount: 4,
                  ),
                ),
              ],
            ),

            Header(
              title: "Profile",
              isProfile: true,
              showShadow: false,
              action: handleClick,
              height: 108,
            ),
          ],
        ),

        // body: Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Header(
        //       title: "Profile",
        //       isProfile: true,
        //       showShadow: false,
        //       action: handleClick,
        //     ),
        //
        //
        //     // Flexible(
        //     //   child: SingleChildScrollView(
        //     //     padding: const EdgeInsets.only(top: 100, bottom: 0),
        //     //     child: Container(
        //     //       decoration: const BoxDecoration(
        //     //         color: Colors.white,
        //     //         borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        //     //       ),
        //     //
        //     //       child: Column(
        //     //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //     //         children: [
        //     //           const InfoCard(),
        //     //
        //     //           Padding(
        //     //             padding: const EdgeInsets.symmetric(vertical: 20.0),
        //     //             child: TabBar(
        //     //                 labelColor: AppColors.primaryColor,
        //     //                 unselectedLabelColor: Colors.black,
        //     //                 isScrollable: true,
        //     //                 indicatorSize: TabBarIndicatorSize.label,
        //     //                 labelPadding: const EdgeInsets.symmetric(horizontal: 30.0),
        //     //                 tabs: List.generate(tabs.length, (index) => Tab(
        //     //                   text: tabs.elementAt(index),
        //     //                 ))
        //     //             ),
        //     //           ),
        //     //
        //     //           const FeedCard(horizontalSpace: 20, isVideo: true),
        //     //           const SizedBox(height: 20,),
        //     //           const FeedCard(horizontalSpace: 20, isVideo: true),
        //     //           const SizedBox(height: 20,),
        //     //         ],
        //     //       ),
        //     //     ),
        //     //   ),
        //     // )
        //   ],
        // ),
      ),
    );
  }
}
