import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
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

  // FETCH USER DETAILS
  Future<void> getUserDetails({int? profileId}) async {
    loading.value = true;
    User? res = await _authService.getUser(uid: profileId);
    user.value = res!;
    loading.value = false;
  }

  void handleClick() {
    Get.toNamed(AppRoutes.PROFILE_EDIT);
  }
}