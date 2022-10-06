import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/custom_header.dart';
import '../../controllers/user_profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../utils/assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/button_widget.dart';

import 'profile_body.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  const UserProfileScreen({Key? key}) : super(key: key);

  // User? get args => Get.arguments;

  User? get _user => controller.user.value;
  double get _toolbarHeight => controller.toolbarHeight();
  bool get _loading => controller.loading();
  List<Feed?> get _feeds => controller.feeds;

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
              feeds: _feeds,
              toolbarHeight: _toolbarHeight,
              fetchingFeeds: controller.feedsLoading(),
              options: PopupMenuButton<int>(
                  padding: const EdgeInsets.only(left: 10, right: 0),
                  onSelected: handleOption,
                  icon: const Icon(Icons.more_horiz_rounded, color: AppColors.lightGrey,),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('Message'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Call"),
                    ),
                  ]
              ),
              button: ButtonWidget(
                text: _user?.follow == 0 ? "Follow" : "Un Follow",
                onPressed: controller.sendFollowReq,
                bgColor: AppColors.primaryColor,
                textColor: Colors.white,
                loader: _loading,
              ),
            ),

            const SizedBox(
                  height: 100,
                  child: CustomHeader(
                      title: "Profile",
                      buttonColor: AppColors.primaryColor,
                      showBottom: false,
                      showSave: false
                  )
            )
          ],
        )),
      ),
    );
  }

  handleOption(int item) {
    switch (item) {
      case 0:
        controller.navigateToChat();
        break;
      case 1:
        controller.navigateToCall();
        break;
    }
  }
}
