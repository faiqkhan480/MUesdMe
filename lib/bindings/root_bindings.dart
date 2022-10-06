import 'package:get/get.dart';

import '../controllers/agora_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/root_controller.dart';
import '../controllers/feed_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(() => RootController());

    Get.put<AgoraController>(AgoraController());
    Get.put<FeedController>(FeedController());
    Get.put<ProfileController>(ProfileController());
    // Get.lazyPut<ProfileController>(() => ProfileController());
  }
}