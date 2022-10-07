import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/header.dart';
import '../../controllers/profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../models/feed.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import 'profile_body.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

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
              height: 300,
              width: double.infinity,
            ),
            (_loading && _user == null) ?
            Center(child: Lottie.asset(Assets.loader)):
            ProfileBody(
              onRefresh: controller.getUserDetails,
              loader: _loading,
              scrollController: controller.scroll(),
              user: _user,
              feeds: _feeds,
              toolbarHeight: _toolbarHeight,
              fetchingFeeds: controller.feedsLoading(),
              // button: ,
            ),

            Header(
                title: "Profile",
                isProfile: true,
                showShadow: false,
                action: controller.handleClick,
                height: 108,
              ),
          ],
        )),
      ),
    );
  }
}
