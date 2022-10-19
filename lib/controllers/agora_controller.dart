import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ringtone_player/ringtone_player.dart';


import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'call_controller.dart';
import 'feed_controller.dart';
import 'message_controller.dart';

class AgoraController extends GetxController {
  AgoraRtmClient? client;
  RxBool isLogin = false.obs;

  final AuthService _service = Get.find<AuthService>();
  final ApiService _apiService = Get.find<ApiService>();

  User? get currentUser => _service.currentUser;

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
      // debugPrint("Public Message from $peerId: ${message.text}");
      int uid = int.parse(peerId.replaceAll("MusedByMe_", ""));
      // debugPrint("Public::::::::::: ${Get.isRegistered<MessageController>()}");
      bool test = Get.isRegistered<MessageController>();

      if(test) {
        MessageController c = Get.find<MessageController>();
        if(c.chat.value.userId == uid) {
          c.messages.insert(0, Message(
              messageDate: DateTime.now(),
              message: message.text,
              chatId: c.chat.value.chatId,
              userId: uid,
              type: "Message"
          ));
        }
      }
    };
    client?.onConnectionStateChanged = (int state, int reason) {
      debugPrint('Connection state changed::::::::::: $state, reason: $reason');
      if (state == 5) {
        client?.logout();
        isLogin.value = false;
        // logController.addLog('Logout.');
      }
    };

    client?.onRemoteInvitationReceivedByPeer = (invite) {
      debugPrint('Invitation::::::::::: ${invite.callerId}, Content: ${invite.content}');
      bool test = Get.isRegistered<FeedController>();
      bool call = Get.isRegistered<CallController>();

      if(test && !call) {
        FeedController c = Get.find<FeedController>();
        String id = invite.callerId.substring(Constants.agoraBaseId.length);
        User? caller = c.users.firstWhereOrNull((element) => element!.userId!.toString() == id);
        RingtonePlayer.ringtone();
        Get.toNamed(AppRoutes.CALL, arguments: Args(broadcaster: caller, callType: CallType.incoming));
      }
    };

    client?.onRemoteInvitationFailure = (invite, errorCode) {
      debugPrint('Remote Invitation Failure::::::::::: ${invite.callerId}, Reason: ${errorCode}');
      RingtonePlayer.stop();
      Get.back();
    };

    client?.onLocalInvitationFailure = (invite, errorCode) {
      debugPrint('Local Invitation Failure::::::::::: ${invite.calleeId}, Reason: ${errorCode}');
      Get.back();
    };

    client?.onLocalInvitationAccepted = (invite) {
      debugPrint('Local Invitation Accepted::::::::::: ${invite.calleeId}, Content: ${invite.content}');
      bool isFeedALive = Get.isRegistered<FeedController>();
      bool isCallControllerALive = Get.isRegistered<CallController>();
      if(isFeedALive && isCallControllerALive) {
        FeedController c = Get.find<FeedController>();
        CallController call = Get.find<CallController>();
        String id = invite.calleeId.substring(Constants.agoraBaseId.length);
        User? callee = c.users.firstWhereOrNull((element) => element!.userId!.toString() == id);
        call.startCall(callee);
      //   // Get.toNamed(AppRoutes.CALL, arguments: Args(broadcaster: caller, callType: CallType.incoming));
      }
    };

    client?.onRemoteInvitationAccepted = (invite) {
      debugPrint('Remote Invitation Accepted::::::::::: ${invite.callerId}, Content: ${invite.content}');
      bool isFeedALive = Get.isRegistered<FeedController>();
      bool isCallControllerALive = Get.isRegistered<CallController>();
      // if(isFeedALive && isCallControllerALive) {
      //   FeedController c = Get.find<FeedController>();
      //   CallController call = Get.find<CallController>();
      //   String id = invite.callerId.substring(Constants.agoraBaseId.length);
      //   User? caller = c.users.firstWhereOrNull((element) => element!.userId!.toString() == id);
      //   call.startCall(caller!);
      //   // Get.toNamed(AppRoutes.CALL, arguments: Args(broadcaster: caller, callType: CallType.incoming));
      // }
    };

    client?.onLocalInvitationRefused = (invite) {
      debugPrint('Local Invitation Refused::::::::::: ${invite.calleeId}, Content: ${invite.content}');
      bool isCallControllerALive = Get.isRegistered<CallController>();
      if(isCallControllerALive) {
        Get.back();
      }
    };

    client?.onRemoteInvitationRefused = (invite) {
      debugPrint('Remote Invitation Refused::::::::::: ${invite.callerId}, Content: ${invite.content}');
      RingtonePlayer.stop();
      // Get.back();
    };

    client?.onLocalInvitationCanceled = (invite) {
      debugPrint('Local Invitation Cancelled::::::::::: ${invite.calleeId}, Content: ${invite.content}');
      RingtonePlayer.stop();
      // Get.back();
    };

    client?.onRemoteInvitationCanceled = (invite) {
      debugPrint('Remote Invitation Canceled::::::::::: ${invite.callerId}, Content: ${invite.content}');
      RingtonePlayer.stop();
      bool isCallControllerALive = Get.isRegistered<CallController>();
      if(isCallControllerALive) {
        Get.back();
      }
      // Get.back();
    };

    await _login();
  }

  // AGORA LOGIN
  Future _login() async {
    debugPrint("LOGIN AGORA:::: MusedByMe_${_service.currentUser?.userId}");
    try {
      await client?.login(_service.rtm, "MusedByMe_${_service.currentUser?.userId}");
      isLogin.value = true;
      if(kDebugMode) {
        Get.snackbar("Success", "Login success!", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (errorCode) {
      String err = errorCode.toString().replaceAll(new RegExp(r'[^0-9]'),'');
      debugPrint('Login error:::: $errorCode');
      if(kDebugMode) {
        Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
      if(int.parse(err) == 6) {
        backToLogin();
      }
    }
  }

  // AGORA RE-LOGIN
  Future reLogin() async {
    debugPrint("LOGIN AGORA:::: MusedByMe_${_service.currentUser?.userId}");
    try {
      await client?.login(_service.rtm, "MusedByMe_${_service.currentUser?.userId}");
      isLogin.value = true;
      if(kDebugMode) {
        Get.snackbar("Success", "Login success!", backgroundColor: Colors.green, colorText: Colors.white);
      }
      return true;
    } catch (errorCode) {
      String err = errorCode.toString().replaceAll(new RegExp(r'[^0-9]'),'');
      debugPrint('Login error:::: $errorCode');
      if(kDebugMode) {
        Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
      if(int.parse(err) == 6) {
        backToLogin();
      }
    }
  }

  logout() {
    client?.logout();
    isLogin.value = false;
  }

  // CHECK USER'S ONLINE STATUS
  Stream<bool> checkStatus(String uid) {
    return Stream.fromFuture(isUserOnline(uid));
    // try {
    //   debugPrint('ID :::: $uid');
    //   Map<dynamic, dynamic>? result = await client?.queryPeersOnlineStatus(["MusedByMe_$uid"]);
    //   // debugPrint('Query result: $result');
    //   bool r = result!["MusedByMe_$uid"] as bool;
    //   yield r;
    // } catch (errorCode) {
    //   // debugPrint('Query error: $errorCode');
    //   yield false;
    // }
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

  // Going back all route/pages until LOGIN page you can even pass a predicate/ condition to pop until that condition passes
  backToLogin () async {
    debugPrint("Token Expired:::::::: ReLogin");
    await _service.clearUser();
    // client?.logout();
    Get.offAllNamed(AppRoutes.LOGIN);
    Get.snackbar("Session Logout", "Your login session is Expired!", backgroundColor: Colors.red, colorText: Colors.white);
  }

  sndInviteToUsers(List<User> users, {User? broadcaster}) async {
    for (var u in users) {
      var res = await _apiService.sendMessage(
          "0",
          '<a href="/golive?appid=${Constants.appId}&channel=${Constants.agoraBaseId}${broadcaster?.userId ?? currentUser?.userId}&token=${_service.rtc}&role=host">Live Invitation</a>'.toString(),
          u.userId.toString(), 0, type: "Invite");
    }
  }
}