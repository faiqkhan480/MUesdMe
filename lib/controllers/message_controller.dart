import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'agora_controller.dart';

class MessageController extends GetxController {
  RxBool loading = true.obs;

  // Rx<User> user = User().obs;
  Rx<Chat> chat = Chat().obs;
  final TextEditingController message = TextEditingController();
  RxList<Message?> messages = List<Message?>.empty(growable: true).obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  final AgoraController _agora = Get.find<AgoraController>();

  var args = Get.arguments;

  AgoraRtmChannel? _channel;

  // RxList comments = [].obs;
  RxList get comments => _agora.comments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(args != null) {
      debugPrint(":::::: ${args}");
      chat.value = args;
    }
    getMessages();
  }

  Future getMessages() async {
    List res = await _service.getAllMessages(chat.value.chatId.toString());
    if(res.isNotEmpty) {
      if(messages.isEmpty) {
        messages.addAll(res as List<Message?>);
      }
      else {
        messages.clear();
        messages.addAll(res as List<Message?>);
      }
      update();
    }
    loading.value = false;
  }

  Future<bool> _isUserOnline(String uid) async {
    try {
      Map<dynamic, dynamic>? result = await _agora.client?.queryPeersOnlineStatus(["MusedByMe_$uid"]);
      debugPrint('Query result: $result');
      bool r = result!["MusedByMe_$uid"] as bool;
      return r;
    } catch (errorCode) {
      debugPrint('Query error: $errorCode');
      return false;
    }
  }

  void _addMessage() {
    comments.insert(0, ChatMessage(uid: "MusedByMe_${chat.value.userId}", message: message.text, type: "sender"));
    message.clear();
  }

  void sendMessage() async {
    debugPrint("${_authService.rtm}");
    // if (_peerUserId.text.isEmpty) {
    //   widget.logController.addLog('Please input peer user id to send message.');
    //   return;
    // }
    if (message.text.isEmpty) {
      return;
    }
    if(await _isUserOnline(chat.value.userId.toString())) {
      try {
        AgoraRtmMessage msg = AgoraRtmMessage.fromText(message.text);
        await _agora.client?.sendMessageToPeer("MusedByMe_${chat.value.userId}", msg, false);
        _addMessage();
      } catch (errorCode) {
        debugPrint(message.text + errorCode.toString());
        Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }
}