import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  handleLogout () async {
    await _authService.clearUser();
    // Going back all route/pages until LOGIN page you can even pass a predicate/ condition to pop until that condition passes
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}