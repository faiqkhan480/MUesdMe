import 'package:get/get.dart';

import '../models/chat.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class ChatController extends GetxController {
  RxList<Chat?> chats = List<Chat?>.empty(growable: true).obs;
  RxBool loading = true.obs;

  final ApiService _service = Get.find<ApiService>();
  // final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getChats();
  }

  Future<void> getChats() async {
    // videos.clear();
    List res = await _service.getAllChats();
    if(res.isNotEmpty) {
      if(chats.isEmpty) {
        chats.addAll(res as List<Chat?>);
      }
      else {
        chats.clear();
        chats.addAll(res as List<Chat?>);
        // feeds.replaceRange(0, (feeds.length-1), res as List<Feed?>);
      }
      update();
    }
    loading.value = false;
  }

  navigateToChat(Chat chat) {
    Get.toNamed(AppRoutes.MESSAGES, arguments: chat);
  }
}