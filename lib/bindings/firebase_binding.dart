import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

class FirebaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PushNotification>(PushNotification());
  }
}