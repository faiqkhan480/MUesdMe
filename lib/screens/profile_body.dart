import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../components/custom_header.dart';
import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/info_card.dart';
import '../controllers/profile_controller.dart';
import '../controllers/user_profile_controller.dart';
import '../models/auths/user_model.dart';
import '../utils/assets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';


class ProfileBody extends StatelessWidget {
  final ProfileController? profileController;
  final UserProfileController? userProfileController;
  // final User? user;
  final User? args;
  // final double toolbarHeight;
  // final bool loader;
  const ProfileBody({
    Key? key,
    // this.user,
    this.args,
    this.profileController,
    this.userProfileController,
    // this.loader = false,
    // this.toolbarHeight = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "My Feed",
      "Images",
      "Videos"
    ];

    User? user = userProfileController?.user.value ?? profileController?.user.value;
    double toolbarHeight = userProfileController?.toolbarHeight() ?? profileController?.toolbarHeight() ?? 35.0;
    bool loader = userProfileController?.loading() ?? userProfileController?.loading() ?? false;

    return Obx(() => Stack(
      children: [
        SizedBox(
          height: 500,
          width: double.infinity,
          // color: Colors.red,
          child: (!loader || user != null) ?
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(Constants.coverImage,
              height: 400,
              fit: BoxFit.cover,
            ),
          ) : null,
        ),
        (loader && user == null) ?
        Center(child: Lottie.asset(Assets.loader)):
        RefreshIndicator(
          onRefresh: profileController != null ? profileController!.getUserDetails : userProfileController!.getUserDetails,
          child: CustomScrollView(
            controller: profileController != null ? profileController!.scroll() : userProfileController!.scroll(),
            slivers: [
              // USER INFO
              SliverAppBar(
                pinned: false,
                expandedHeight: 300.0,
                automaticallyImplyLeading: false,
                // flexibleSpace: Image.network(Constants.coverImage,
                //   height: 400,
                //   fit: BoxFit.cover,
                // ),
                toolbarHeight: 300,
                backgroundColor: Colors.transparent,
                // excludeHeaderSemantics: true,
                bottom: PreferredSize(
                  preferredSize: const Size(double.infinity, 180),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                    ),
                    child: InfoCard(
                      // user: (args != null) ? _controller.profile.value : _controller.user.value,
                      user: user,
                      button: (args != null) ?
                      ButtonWidget(
                        text: user?.follow == 0 ? "Follow" : "Un Follow",
                        onPressed: profileController != null ? profileController!.sendFollowReq : userProfileController!.sendFollowReq,
                        bgColor: AppColors.primaryColor,
                        textColor: Colors.white,
                        loader: loader,
                      ) : null,
                    ),
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
        ),

        if(args != null)
          const SizedBox(
              height: 100,
              child: CustomHeader(
                  title: "Profile",
                  buttonColor: AppColors.primaryColor,
                  showBottom: false,
                  showSave: false
              ))
        else
          Header(
            title: "Profile",
            isProfile: true,
            showShadow: false,
            action: profileController != null ? profileController!.handleClick : userProfileController!.handleClick,
            // action: _controller.handleClick,
            height: 108,
          ),
      ],
    ));
  }
}
