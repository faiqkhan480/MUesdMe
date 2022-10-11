import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'agora_controller.dart';
import 'chat_controller.dart';

class MessageController extends GetxController {
  RxBool loading = true.obs;
  RxBool emojiShowing = false.obs;
  RxBool fetching = false.obs;

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
    if(args != null && args is Chat) {
      chat.value = args;
      getMessages();
    }

    // comments.addListener(GetStream(
    //   onListen: appendMsg,
    // ));
    // comments.listen((p) {
    //   debugPrint(":::::T:::::: ${comments.length}");
    //   int uid = int.parse(comments.first.uid.replaceAll("MusedByMe_", ""));
    //
    //   // messages.insert(0, Message(
    //   //     userId: uid,
    //   //     chatId: chat.value.chatId,
    //   //     message: comments.first.message,
    //   //     messageDate: DateTime.now())
    //   // );
    // });
  }

  appendMsg() {
    // List<Message?> m = comments.where((msg) => msg?.userId == _authService.currentUser?.userId || msg?.userId == chat.value.userId).toList() as List<Message?>;
  }

  Future getMessages() async {
    _agora.setCurrentId(chat.value.chatId!);
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
    comments.insert(0, Message(
      messageDate: DateTime.now(),
      message: message.text,
      chatId: 0,
      userId: chat.value.userId,
    ));
    // comments.insert(0, ChatMessage(uid: "MusedByMe_${chat.value.userId}", message: message.text, type: "sender"));
    messages.insert(0, Message(userId: _authService.currentUser!.userId!, chatId: chat.value.chatId, message: message.text, messageDate: DateTime.now()));
    _service.sendMessage(chat.value.chatId.toString(), message.text, chat.value.userId.toString());
    message.clear();
  }

  void sendMessage() async {
    debugPrint("${_authService.rtm}");
    if (message.text.isEmpty) {
      return;
    }
    fetching.value = true;
    if(await _isUserOnline(chat.value.userId.toString())) {
      try {
        AgoraRtmMessage msg = AgoraRtmMessage.fromText(message.text);
        await _agora.client?.sendMessageToPeer("MusedByMe_${chat.value.userId}", msg, false);
        _addMessage();
        fetching.value = false;
      } catch (errorCode) {
        debugPrint(message.text + errorCode.toString());
        fetching.value = false;
        Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    else {
      var res = await _service.sendMessage(chat.value.chatId.toString(), message.text, chat.value.userId.toString());
      if(res == true) {
        messages.insert(0, Message(userId: _authService.currentUser!.userId!, chatId: chat.value.chatId, message: message.text, messageDate: DateTime.now()));
        message.clear();
      }
      fetching.value = false;
    }
  }

  onPressed() {
    emojiShowing.value = !emojiShowing.value;
  }
}