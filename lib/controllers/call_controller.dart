import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'agora_controller.dart';

class CallController extends GetxController {
  RxBool loading = true.obs;

  Rx<User> user = User().obs;
  Rx<CallType> type = CallType.outgoing.obs;

  final AuthService _authService = Get.find<AuthService>();

  final AgoraController _agora = Get.find<AgoraController>();

  Args? args = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(args != null) {
      user.value = args!.broadcaster!;
      loading.value = false;
      type.value = args!.callType;
      _sndCallInvite();
    }
  }

  Future<void> _sndCallInvite() async {


    try {
      AgoraRtmLocalInvitation invitation = AgoraRtmLocalInvitation("${Constants.agoraBaseId}${user.value.userId}", content: "Call");
      await _agora.client?.sendLocalInvitation(invitation.toJson());
    } catch (errorCode) {
      Get.snackbar("Failed!", "Cant connect call right now!", backgroundColor: Colors.red, colorText: Colors.white);
      Get.back(closeOverlays: false);
    }
  }

  Future<void> endCall() async {
    if(type.value == CallType.incoming) {
      try {
        AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation("${Constants.agoraBaseId}${user.value.userId}", content: "Call");
        await _agora.client?.refuseRemoteInvitation(invitation.toJson());
      } catch (errorCode) {
        debugPrint("Error::::::::::::::::$errorCode");
      }
    }
    Get.back();
  }

  Future<void> acceptCallInvite() async {
    try {
      AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation("${Constants.agoraBaseId}${user.value.userId}", content: "Call");
      await _agora.client?.acceptRemoteInvitation(invitation.toJson());
    } catch (errorCode) {
      Get.snackbar("Failed!", "Cant connect call right now!", backgroundColor: Colors.red, colorText: Colors.white);
      Get.back(closeOverlays: false);
    }
  }

  Future<void> startCall(User u) async {

  }
}