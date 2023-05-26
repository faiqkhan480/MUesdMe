import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/chat.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class ChatController extends GetxController {
  RxList<Chat?> _allChats = List<Chat?>.empty(growable: true).obs;
  RxList<Chat?> chats = List<Chat?>.empty(growable: true).obs;
  RxBool loading = true.obs;

  TextEditingController search = TextEditingController();

  final ApiService _service = Get.find<ApiService>();
  // final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getChats();
  }

  Future<void> getChats() async {
    List res = await _service.getAllChats();
    if(res.isNotEmpty) {
      if(_allChats.isEmpty) {
        _allChats.addAll(res as List<Chat?>);
      }
      else {
        _allChats.clear();
        _allChats.addAll(res as List<Chat?>);
        // feeds.replaceRange(0, (feeds.length-1), res as List<Feed?>);
      }
      chats.clear();
      chats.assignAll(_allChats);
      update();
    }
    loading.value = false;
  }

  navigateToChat(Chat chat) {
    Get.toNamed(AppRoutes.MESSAGES, arguments: chat);
  }

  onChange(String value) {
    List<Chat?> res = _allChats.where((c) => c!.fullName!.toLowerCase().contains(value.toLowerCase())).toList();
    chats.clear();
    chats.assignAll(res);
    update();
  }
}