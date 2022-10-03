import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/header.dart';
import '../../controllers/profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';
import 'profile_body.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

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
            SizedBox(
              height: 500,
              width: double.infinity,
              child: (!_loading || _user != null) ?
              Align(
                alignment: Alignment.topCenter,
                child: Image.network(Constants.coverImage,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ) : null,
            ),
            (_loading && _user == null) ?
            Center(child: Lottie.asset(Assets.loader)):
            ProfileBody(
              onRefresh: controller.getUserDetails,
              loader: _loading,
              controller: controller.scroll(),
              user: _user,
              toolbarHeight: _toolbarHeight,
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
