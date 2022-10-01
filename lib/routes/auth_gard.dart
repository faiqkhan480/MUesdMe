import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import 'app_routes.dart';

class AuthGuard extends GetMiddleware {
//   Get the auth service
  final AuthService authService = Get.find<AuthService>();

//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint("isAuthenticated::::: ${authService.isAuthenticated}");
    // Navigate to login if client is not authenticated other wise continue
    // if (authService.isAuthenticated) {
    //   return const RouteSettings(name: AppRoutes.ROOT);
    // }
    // else {
      return const RouteSettings(name: AppRoutes.LOGIN);
    // }
  }
}