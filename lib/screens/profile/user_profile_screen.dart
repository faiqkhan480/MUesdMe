import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/custom_header.dart';
import '../../controllers/user_profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../utils/assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/button_widget.dart';

import 'profile_body.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  const UserProfileScreen({Key? key}) : super(key: key);

  // User? get args => Get.arguments;

  User? get _user => controller.user.value;
  double get _toolbarHeight => controller.toolbarHeight();
  bool get _loading => controller.loading();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Obx(() => Stack(
          children: [
            Container(
              height: 500,
              width: double.infinity,
              decoration: (!_loading || _user?.userId != null) ? const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange,
                      AppColors.primaryColor,
                      AppColors.pinkColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )
              ) : null,
              // child: (!_loading || _user?.userId != null) ?
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Image.network(Constants.coverImage,
              //     height: 400,
              //     fit: BoxFit.cover,
              //   ),
              // ) : null,
            ),
            (_loading && _user?.userId == null) ?
            Center(child: Lottie.asset(Assets.loader)):
            ProfileBody(
              onRefresh: controller.getUserDetails,
              loader: _loading,
              controller: controller.scroll(),
              user: _user,
              toolbarHeight: _toolbarHeight,
              button: ButtonWidget(
                text: _user?.follow == 0 ? "Follow" : "Un Follow",
                onPressed: controller.sendFollowReq,
                bgColor: AppColors.primaryColor,
                textColor: Colors.white,
                loader: _loading,
              ),
            ),
            // RefreshIndicator(
            //   onRefresh: _controller.getUserDetails,
            //   child: CustomScrollView(
            //     controller: _controller.scroll(),
            //     slivers: [
            //       // USER INFO
            //       SliverAppBar(
            //         pinned: false,
            //         expandedHeight: 300.0,
            //         automaticallyImplyLeading: false,
            //         // flexibleSpace: Image.network(Constants.coverImage,
            //         //   height: 400,
            //         //   fit: BoxFit.cover,
            //         // ),
            //         toolbarHeight: 300,
            //         backgroundColor: Colors.transparent,
            //         // excludeHeaderSemantics: true,
            //         bottom: PreferredSize(
            //           preferredSize: const Size(double.infinity, 180),
            //           child: Container(
            //             decoration: const BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.vertical(top: Radius.circular(20))
            //             ),
            //             child: InfoCard(
            //               // user: (args != null) ? _controller.profile.value : _controller.user.value,
            //               user: _user,
            //               button: (args != null) ?
            //               ButtonWidget(
            //                 text: _user?.follow == 0 ? "Follow" : "Un Follow",
            //                 // text: "${_controller.profile.value.follow}",
            //                 onPressed: _controller.sendFollowReq,
            //                 bgColor: AppColors.primaryColor,
            //                 textColor: Colors.white,
            //                 loader: _loader,
            //               ) : null,
            //             ),
            //           ),
            //         ),
            //       ),
            //
            //       // TAB BAR
            //       SliverAppBar(
            //         pinned: true,
            //         expandedHeight: 50,
            //         // collapsedHeight: 0,
            //         toolbarHeight: _toolbarHeight,
            //         bottom: PreferredSize(
            //             preferredSize: const Size(double.infinity, 0),
            //             child: Row(
            //               children: [
            //                 TabBar(
            //                     labelColor: AppColors.primaryColor,
            //                     unselectedLabelColor: Colors.black,
            //                     isScrollable: true,
            //                     indicatorSize: TabBarIndicatorSize.label,
            //                     labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            //                     indicator: const UnderlineTabIndicator(
            //                         borderSide: BorderSide(width: 2.5, color: AppColors.primaryColor),
            //                         insets: EdgeInsets.symmetric(horizontal: 35.0)),
            //                     tabs: List.generate(tabs.length, (index) => Tab(
            //                       text: tabs.elementAt(index),
            //                     ))
            //                 ),
            //               ],
            //             )
            //         ),
            //       ),
            //
            //       // FEEDS LIST
            //       SliverList(
            //         delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            //           return Container(
            //             color: Colors.white,
            //             padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            //             child: const FeedCard(horizontalSpace: 10, index: 0),
            //           );
            //         },
            //           childCount: 4,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(
                  height: 100,
                  child: CustomHeader(
                      title: "Profile",
                      buttonColor: AppColors.primaryColor,
                      showBottom: false,
                      showSave: false
                  ))
          ],
        )),
      ),
    );
  }
}
