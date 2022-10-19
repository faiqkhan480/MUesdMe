import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ringtone_player/ringtone_player.dart';

import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'agora_controller.dart';
import 'feed_controller.dart';

class CallController extends GetxController {
  RxBool loading = true.obs;
  RxBool localUserJoined = false.obs;

  Rx<User> user = User().obs;
  RxInt remoteUid = 0.obs;
  Rx<CallType> type = CallType.outgoing.obs;

  RxString channelId = ''.obs;

  final AuthService _authService = Get.find<AuthService>();
  final FeedController _feedController = Get.find<FeedController>();

  final AgoraController _agora = Get.find<AgoraController>();

  Args? args = Get.arguments;

  RtcEngine? engine;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(args != null) {
      user.value = args!.broadcaster!;
      loading.value = false;
      type.value = args!.callType;
      if(args!.callType == CallType.outgoing) {
        _sndCallInvite();
      }
    }
  }

  @override
  void onClose() {
    if(type.value == CallType.outgoing) {
      _refuseLocalInvitation();
    }
    else if(type.value == CallType.incoming) {
      _refuseRemoteInvitation();
    }
    // destroy sdk and leave channel
    engine?.leaveChannel();
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initializeAgora(String channelName, String rtcToken, int uid) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    await _initAgoraRtcEngine();

    // if (args["isBroadcaster"]) streamId = await engine?.createDataStream(false, false);


    await engine?.joinChannel(rtcToken, channelName, null, uid);
  }

  // <----------------START RTC------------------> //
  Future<void> _initAgoraRtcEngine() async {
    engine = await RtcEngine.create(Constants.appId);
    _addListeners();

    // await engine?.enableVideo();
    //
    // await engine?.startPreview();

    // bool? suported = await engine?.isCameraTorchSupported();

    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine?.setClientRole(ClientRole.Broadcaster);
  }

  void _addListeners() {
    engine?.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        debugPrint('RTC warning::::: $warningCode');
      },
      error: (errorCode) {
        debugPrint('RTC error:::::: $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('RTC joinChannelSuccess $channel $uid $elapsed');
        localUserJoined.value = true;
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined RTC::::::::: $uid $elapsed');
        remoteUid.value = uid;
        //   remoteUid.add(uid);
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline  $uid $reason');
        remoteUid.value = 0;
      },
      leaveChannel: (stats) {
        debugPrint('RTC leaveChannel ${stats.toJson()}');
        if(type.value == CallType.ongoing) {
          endCall();
        }
        // localUserJoined.value = false;
      },

    ));
  }

  // <----------------END RTC------------------> //

  Future<void> _sndCallInvite() async {
    channelId.value = "${Constants.agoraBaseId}${_authService.currentUser?.userId}";
    String callee = "${Constants.agoraBaseId}${user.value.userId}";
    // debugPrint("sndCallInvite:::::::::::::::::::$channelId");
    try {
      await initializeAgora(channelId.value, _authService.rtc!, _authService.currentUser!.userId!);
      AgoraRtmLocalInvitation invitation = AgoraRtmLocalInvitation(callee, content: "Call");
      await _agora.client?.sendLocalInvitation(invitation.toJson());
    }
    catch (errorCode) {
      debugPrint("ERROR::::::::::::::$errorCode");
      // Get.snackbar("Failed!", "Cant connect call right now!", backgroundColor: Colors.red, colorText: Colors.white);
      // Get.back(closeOverlays: false);
    }
  }

  Future<void> _refuseRemoteInvitation() async {
    try {
      AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation("${Constants.agoraBaseId}${user.value.userId}", content: "Call");
      await _agora.client?.refuseRemoteInvitation(invitation.toJson());
    } catch (errorCode) {
      debugPrint("Error::::::::::::::::$errorCode");
    }
  }

  Future<void> _refuseLocalInvitation() async {
    try {
      AgoraRtmLocalInvitation invitation = AgoraRtmLocalInvitation("${Constants.agoraBaseId}${user.value.userId}", content: "Call");
      await _agora.client?.cancelLocalInvitation(invitation.toJson());
    } catch (errorCode) {
      debugPrint("Error::::::::::::::::$errorCode");
    }
  }

  Future<void> acceptCallInvite() async {
    channelId.value = "${Constants.agoraBaseId}${user.value.userId}";
    User? callee = _feedController.users.firstWhereOrNull((u) => u?.userId == user.value.userId);
    // debugPrint("ACCEPT INVITE::::::::${channelId.value}");
    // debugPrint("MY RTC::::::::${_authService.rtc}");
    // debugPrint("USER RTC::::::::${callee?.rtcToken}");

    try {
      await initializeAgora(channelId.value, callee!.rtcToken!, _authService.currentUser!.userId!);
      // await engine?.enableVideo();
      //
      // await engine?.startPreview();
      AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation(channelId.value, content: "Call");
      await _agora.client?.acceptRemoteInvitation(invitation.toJson());
      startCall(callee);
    } catch (errorCode) {
      debugPrint("::::::::::::::$errorCode");
      // Get.snackbar("Failed!", "Cant connect call right now!", backgroundColor: Colors.red, colorText: Colors.white);
      // Get.back(closeOverlays: false);
    }
  }

  Future<void> startCall([User? u]) async {
    debugPrint("StartCall::::::::");
    type.value = CallType.ongoing;
    await engine?.enableVideo();

    await engine?.startPreview();
  }

  void endCall() {
    RingtonePlayer.stop();
    Get.back();
  }

  void endBroadcast() async {
    engine?.leaveChannel();
  }

  void switchVideo() async {
    try{
      engine?.leaveChannel();
      User? callee = _feedController.users.firstWhereOrNull((u) => u?.userId == 1);
      await initializeAgora(channelId.value, callee!.rtcToken!, _authService.currentUser!.userId!);
      await engine?.enableVideo();

      await engine?.startPreview();
      // debugPrint("SwitchVideo::::::::::::::");
      // await engine?.enableVideo();
      // await engine?.enableAudio();
      // await engine?.startPreview();
    }
    catch(error) {
      debugPrint("::::::::::::RRR:::${error}");
    }
  }
}