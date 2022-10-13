import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musedme/controllers/message_controller.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class AgoraController extends GetxController {
  AgoraRtmClient? client;

  final AuthService _service = Get.find<AuthService>();

  RxList comments = [].obs;

  RxInt currentId = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _createClient();
  }

  // CREATE AGORA CLIENT FOR USER
  Future _createClient() async {
    client = await AgoraRtmClient.createInstance(Constants.appId);

    client?.onMessageReceived = (AgoraRtmMessage message, String peerId) async {
      debugPrint("Public Message from $peerId: ${message.text}");
      int uid = int.parse(peerId.replaceAll("MusedByMe_", ""));
      debugPrint("Public::::::::::: ${Get.isRegistered<MessageController>()}");
      bool test = Get.isRegistered<MessageController>();
      if(test) {
        MessageController c = Get.find<MessageController>();
        c.messages.insert(0, Message(
          messageDate: DateTime.now(),
          message: message.text,
          chatId: c.chat.value.chatId,
          userId: uid,
        ));
      }
      // if(uid == currentId.value) {
      //   comments.insert(0, Message(
      //     messageDate: DateTime.now(),
      //     message: message.text,
      //     chatId: 0,
      //     userId: uid,
      //   ));
      // }
    };
    client?.onConnectionStateChanged = (int state, int reason) {
      debugPrint('Connection state changed::::::::::: $state, reason: $reason');
      if (state == 5) {
        client?.logout();
        // logController.addLog('Logout.');
      }
    };
    await _login();
  }

  // AGORA LOGIN
  Future _login() async {
    debugPrint("LOGIN AGORA:::: MusedByMe_${_service.currentUser?.userId}");
    try {
      await client?.login(_service.rtm, "MusedByMe_${_service.currentUser?.userId}");
      // Get.snackbar("Success", "Login success!", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (errorCode) {
      debugPrint('Login error:::: $errorCode');
      // Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      client?.logout();
      await _login();
    }
  }

  // CHECK USER'S ONLINE STATUS
  Stream<bool> checkStatus(String uid) async* {
    try {
      // debugPrint('ID :::: $uid');
      Map<dynamic, dynamic>? result = await client?.queryPeersOnlineStatus(["MusedByMe_$uid"]);
      // debugPrint('Query result: $result');
      bool r = result!["MusedByMe_$uid"] as bool;
      yield r;
    } catch (errorCode) {
      // debugPrint('Query error: $errorCode');
      yield false;
    }
  }

  Future<bool> isUserOnline(String uid) async {
    try {
      Map<dynamic, dynamic>? result = await client?.queryPeersOnlineStatus(["MusedByMe_$uid"]);
      debugPrint('Query result: $result');
      bool r = result!["MusedByMe_$uid"] as bool;
      return r;
    } catch (errorCode) {
      debugPrint('Query error: $errorCode');
      return false;
    }
  }

  setCurrentId(int id) {
    currentId.value = id;
  }

  clearChat() {
    comments.clear();
  }
}