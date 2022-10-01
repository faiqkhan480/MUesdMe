import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class SearchController extends GetxController {
  RxList<User?> users = List<User?>.empty(growable: true).obs;
  RxBool loading = false.obs;
  RxBool searchResult = false.obs;

  // final ProfileController _profile = Get.find<ProfileController>();
  final ApiService _service = Get.find<ApiService>();


  // FETCH FEEDS
  Future<void> getUsers(String? search) async {
    users.clear();
    loading.value = true;
    List<User?> res = await _service.fetchUsers(search ?? "");
    users.addAll(res);
    searchResult.value = res == [];
    loading.value = false;
  }

  // HANDLE ON CLICK USER
  void handleNavigation(User u) {
    // _profile.getProfileDetails(u.userId!);
    Get.toNamed(AppRoutes.USER_PROFILE, arguments: u);
    // Navigator.push(context, CupertinoPageRoute(builder: (context) => ProfileScreen(profile: u),));
  }
}