import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class UserProfileController extends GetxController {
  RxBool loading = true.obs;
  RxDouble toolbarHeight = 35.0.obs;

  Rx<User> user = User().obs;
  final Rx<ScrollController> scroll = ScrollController().obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scroll.value.addListener(() {
      if(scroll.value.position.pixels > 540) {
        toolbarHeight.value = 120;

      } else if(scroll.value.position.pixels < 620) {
        toolbarHeight.value = 35;
      }
    });
    getUserDetails();
  }

  // FETCH DATA
  Future<void> getUserDetails({int? profileId}) async {
    User? args = Get.arguments;
    loading.value = true;
    User? res = await _authService.getUser(uid: args?.userId, followedBy: _authService.currentUser?.userId);
    user.value = res!;
    loading.value = false;
  }

  Future<void> sendFollowReq() async {
    loading.value = true;
    // debugPrint("UID ${profile.value.userId} FOLLOW${profile.value.follow}");
    User? res = await _service.followReq((user.value.userId ?? "").toString(), user.value.follow ?? 0);
    user.value.follow = user.value.follow == 0 ? 1 : 0;
    user.value.followers = res?.followers;
    loading.value = false;
  }

  void handleClick() {
    Get.to(AppRoutes.PROFILE_EDIT, transition: Transition.leftToRight);
  }

  navigateToChat() {
    Get.toNamed(AppRoutes.CHAT, arguments: user.value);
  }

  navigateToCall() {
    Get.toNamed(AppRoutes.CALL, arguments: user.value);
  }
}