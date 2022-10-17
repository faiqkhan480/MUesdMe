import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musedme/controllers/feed_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'agora_controller.dart';
import 'chat_controller.dart';

class MessageController extends GetxController {
  RxBool loading = true.obs;
  RxBool emojiShowing = false.obs;
  RxBool fetching = false.obs;
  
  RxBool isOnline = false.obs;

  // Rx<User> user = User().obs;
  Rx<Chat> chat = Chat().obs;
  final TextEditingController message = TextEditingController();
  RxList<Message?> messages = List<Message?>.empty(growable: true).obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  final List<User?> _users = Get.find<FeedController>().users;

  final AgoraController _agora = Get.find<AgoraController>();

  var args = Get.arguments;

  AgoraRtmChannel? _channel;

  // RxList comments = [].obs;
  // RxList get comments => _agora.comments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(_agora.isLogin()) {
      initialize();
    }
    else {
      _agora.reLogin().then((value) => initialize());
    }
  }

  initialize() {
    if(args != null && args is Chat) {
      chat.value = args;
      getMessages();
    }

    isOnline.addListener(GetStream(
      onListen: () async {
        bool res = await _agora.isUserOnline(chat.value.userId.toString());
        isOnline.value = res;
      },
    ));
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
    // comments.insert(0, Message(
    //   messageDate: DateTime.now(),
    //   message: message.text,
    //   chatId: 0,
    //   userId: chat.value.userId,
    //   type: "Message"
    // ));
    messages.insert(0, Message(userId: _authService.currentUser!.userId!, chatId: chat.value.chatId, message: message.text, messageDate: DateTime.now(), type: "Message"));
    _service.sendMessage(chat.value.chatId.toString(), message.text, chat.value.userId.toString(), 1);
    message.clear();
  }

  void sendMessage() async {
    debugPrint("${_authService.rtm}");
    if (message.text.isEmpty) {
      return;
    }
    fetching.value = true;
    // FOR ONLINE USER
    if(await _isUserOnline(chat.value.userId.toString())) {
      try {
        AgoraRtmMessage msg = AgoraRtmMessage.fromText(message.text);
        await _agora.client?.sendMessageToPeer("MusedByMe_${chat.value.userId}", msg, false);
        fetching.value = false;
      } catch (errorCode) {
        debugPrint(message.text + errorCode.toString());
        fetching.value = false;
        Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
      _addMessage();
    }
    // FOR OFFLINE USER
    else {
      var res = await _service.sendMessage(chat.value.chatId.toString(), message.text, chat.value.userId.toString(), 0);
      if(res == true) {
        messages.insert(0, Message(userId: _authService.currentUser!.userId!, chatId: chat.value.chatId, message: message.text, messageDate: DateTime.now(), type: 'Message'));
        message.clear();
      }
      fetching.value = false;
    }
  }

  onPressed() {
    emojiShowing.value = !emojiShowing.value;
  }

  handleInvite(Message invite) async {
    await [Permission.camera, Permission.microphone].request();
    Get.toNamed(AppRoutes.LIVE, arguments: {
      "isBroadcaster": true,
      'broadcaster': _users.firstWhereOrNull((u) => u?.userId == invite.userId)
    });
  }
}