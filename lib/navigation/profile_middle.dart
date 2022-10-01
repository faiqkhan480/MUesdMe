import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileMiddle extends GetMiddleware {
//   Get the auth service
//   final ProfileMiddle authService = Get.find<ProfileMiddle>();

//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint("isAuthenticated::::: ${Get.arguments}");
    // Navigate to login if client is not authenticated other wise continue
    // if (authService.isAuthenticated) {
    //   return const RouteSettings(name: AppRoutes.ROOT);
    // }
    // else {
    return null;
    // }
  }
}