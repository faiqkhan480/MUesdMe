import 'package:get/get.dart';

import '../routes/app_routes.dart';

class SettingsController extends GetxController {

  handleLogout () {
    // Going back all route/pages until LOGIN page you can even pass a predicate/ condition to pop until that condition passes
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}