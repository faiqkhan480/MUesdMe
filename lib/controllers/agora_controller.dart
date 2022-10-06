import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class AgoraController extends GetxController {
  AgoraRtmClient? client;

  final AuthService _service = Get.find<AuthService>();

  RxList comments = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _createClient();
  }

  // CREATE AGORA CLIENT FOR USER
  Future _createClient() async {
    client = await AgoraRtmClient.createInstance(Constants.appId);
    debugPrint("RTM Initialize::::::::");

    client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      debugPrint("Public Message from $peerId: ${message.text}");
      comments.insert(0, Chat(uid: peerId, message: message.text, type: "receiver"));
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
    try {
      await client?.login(_service.rtm, "MusedByMe_${_service.currentUser?.userId}");
      Get.snackbar("Success", "Login success!", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (errorCode) {
      debugPrint('Login error:::: $errorCode');
      Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // CHECK USER'S ONLINE STATUS
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
}