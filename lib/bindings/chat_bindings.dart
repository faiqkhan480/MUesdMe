import 'package:get/get.dart';

import '../controllers/message_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}