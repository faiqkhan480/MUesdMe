import 'package:flutter/material.dart';

import '../../components/feed_card.dart';
import '../../components/info_card.dart';
import '../../models/auths/user_model.dart';
import '../../utils/app_colors.dart';


class ProfileBody extends StatelessWidget {
  final User? user;
  final double toolbarHeight;
  final bool loader;
  final Future Function() onRefresh;
  final ScrollController? controller;
  final Widget? button;
  const ProfileBody({
    Key? key,
    this.user,
    this.controller,
    this.loader = false,
    required this.onRefresh,
    this.toolbarHeight = 0,
    this.button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "My Feed",
      "Images",
      "Videos"
    ];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          // USER INFO
          SliverAppBar(
            pinned: false,
            expandedHeight: 300.0,
            automaticallyImplyLeading: false,
            toolbarHeight: 300,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 180),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: InfoCard(
                  user: user,
                  button: button
                ),
              ),
            ),
          ),

          // TAB BAR
          SliverAppBar(
            pinned: true,
            expandedHeight: 50,
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

          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: SliverPersistentH,
          // ),

          // FEEDS LIST
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: const FeedCard(horizontalSpace: 10, index: 0),
              );
            },
              childCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
