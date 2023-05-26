import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ringtone_player/ringtone_player.dart';

import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'agora_controller.dart';
import 'feed_controller.dart';
import 'notification_controller.dart';

class CallController extends GetxController {
  RxBool loading = true.obs;
  RxBool localUserJoined = false.obs;

  Rx<User> user = User().obs;
  RxInt remoteUid = 0.obs;
  Rx<CallType> type = CallType.outgoing.obs;

  RxList<int> users = <int>[].obs;

  RxString channelId = ''.obs;

  final AuthService _authService = Get.find<AuthService>();
  final FeedController _feedController = Get.find<FeedController>();
  final PushNotification _notification = Get.find<PushNotification>();

  final AgoraController _agora = Get.find<AgoraController>();

  Args? args = Get.arguments;

  RtcEngine? engine;

  RxBool speakerOn = false.obs;
  RxBool mic = false.obs;
  RxBool cameraBack = false.obs;
  RxBool isVideo = false.obs;


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
      else if(args!.callType == CallType.notification) {
        acceptCallDirectly();
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

  // INITIALIZE AGORA RTC ENGINE
  Future<void> initializeAgora(String channelName, String rtcToken, int uid) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    await _initAgoraRtcEngine();

    // if (args["isBroadcaster"]) streamId = await engine?.createDataStream(false, false);


    await engine?.joinChannel(rtcToken, channelName, null, uid);
  }

  // <----------------START RTC------------------> //
  // CREATE RTC ENGINE
  Future<void> _initAgoraRtcEngine() async {
    engine = await RtcEngine.create(Constants.appId);
    _addListeners();

    if(args?.callMode == CallType.video) {
      isVideo.value = true;
      await engine?.enableVideo();
      await engine?.startPreview();
      await engine?.enableLocalVideo(true);
    }
    else {
      isVideo.value = false;
    //   await engine?.disableVideo();
    //   await engine?.enableLocalVideo(false);
    }

    // bool? suported = await engine?.isCameraTorchSupported();

    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine?.setClientRole(ClientRole.Broadcaster);
  }

  // RTC EVENT LISTENER
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
        users.add(uid);
        update();
        //   remoteUid.add(uid);
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline  $uid $reason');
        remoteUid.value = 0;
        users.removeWhere((u) => u == uid);
        update();
        if(reason == UserOfflineReason.Quit && type.value == CallType.ongoing && users.isEmpty) {
          endCall();
        }
      },
      leaveChannel: (stats) {
        debugPrint('RTC leaveChannel ${stats.toJson()}');
        if(type.value == CallType.ongoing && Get.currentRoute == AppRoutes.CALL) {
          endCall();
        }
        // localUserJoined.value = false;
      },

      videoPublishStateChanged: (channel, oldState, newState, elapseSinceLastState) {
        debugPrint("VideoPublishStateChanged :::::: channel$channel., oldState$oldState newState$newState");
      },

      localPublishFallbackToAudioOnly: (isFallbackOrRecover) {
        debugPrint("LocalPublishFallbackToAudioOnly :::::: $isFallbackOrRecover");
      },

      remoteSubscribeFallbackToAudioOnly: (uid, isFallbackOrRecover) {
        debugPrint("RemotePublishFallbackToAudioOnly :::::: uid$uid :: $isFallbackOrRecover");
      },

      localVideoStateChanged: (localVideoState, error) {
        debugPrint("LocalVideoState :::::: STATE$localVideoState., ERROR$error");
      },

      remoteVideoStateChanged: (uid, state, reason, elapsed) {
        debugPrint("RemoteVideoState :::::: UID$uid., STATE$state, REASON$reason");
      },

    ));
  }

  // <----------------END RTC------------------> //

  // <----------------RTM HANDLERS------------------> //
  // SND RTM INVITE TO CALLEE
  Future<void> _sndCallInvite() async {
    debugPrint("SEND CALL INVITE::::::::::::::${user.value.fcmToken}");
    channelId.value = "${Constants.agoraBaseId}${_authService.currentUser?.userId}";
    String callee = "${Constants.agoraBaseId}${user.value.userId}";
    bool res = await _agora.isUserOnline(user.value.userId.toString());
    // if(!res) {
    //   _notification.sndFCMNotification(user.value.fcmToken, user.value, args?.callMode == CallType.video ? "Video" : "Audio");
    // }

    try {
      AgoraRtmLocalInvitation invitation = AgoraRtmLocalInvitation(callee, content: args?.callMode == CallType.video ? "Video" : "Audio");
      await _agora.client?.sendLocalInvitation(invitation.toJson());
    }
    catch (errorCode) {
      debugPrint("ERROR::::::::::::::$errorCode");
    }
  }

  // REJECT RTM INVITE COMES FROM REMOTE USER
  Future<void> _refuseRemoteInvitation() async {
    try {
      AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation("${Constants.agoraBaseId}${user.value.userId}", content: args?.callMode == CallType.video ? "Video" : "Audio");
      await _agora.client?.refuseRemoteInvitation(invitation.toJson());
    } catch (errorCode) {
      debugPrint("Remote Error::::::::::::::::$errorCode");
    }
  }

  // CANCEL THE RTM LOCAL INVITE
  Future<void> _refuseLocalInvitation() async {
    try {
      AgoraRtmLocalInvitation invitation = AgoraRtmLocalInvitation("${Constants.agoraBaseId}${user.value.userId}", content: args?.callMode == CallType.video ? "Video" : "Audio");
      await _agora.client?.cancelLocalInvitation(invitation.toJson());
    } catch (errorCode) {
      debugPrint("LOCAL Error::::::::::::::::$errorCode");
    }
  }

  // ACCEPT RTM INVITE COMES FROM REMOTE USER
  Future<void> acceptCallInvite() async {
    debugPrint("AcceptCall::::::::");
    channelId.value = "${Constants.agoraBaseId}${user.value.userId}";
    User? callee = _feedController.users.firstWhereOrNull((u) => u?.userId == user.value.userId);
    RingtonePlayer.stop();

    try {
      AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation(channelId.value, content: args?.callMode == CallType.video ? "Video" : "Audio");
      await _agora.client?.acceptRemoteInvitation(invitation.toJson());
      await initializeAgora(channelId.value, callee!.rtcToken!, _authService.currentUser!.userId!);
      startCall();
    } catch (errorCode) {
      debugPrint("::::::::::::::$errorCode");
    }
  }

  Future<void> acceptCallDirectly() async {
    debugPrint("AcceptCall::::::::");
    channelId.value = "${Constants.agoraBaseId}${user.value.userId}";
    User? callee = _feedController.users.firstWhereOrNull((u) => u?.userId == user.value.userId);
    RingtonePlayer.stop();

    try {
      // AgoraRtmRemoteInvitation invitation = AgoraRtmRemoteInvitation(channelId.value, content: args?.callMode == CallType.video ? "Video" : "Audio");
      // await _agora.client?.acceptRemoteInvitation(invitation.toJson());
      await initializeAgora(channelId.value, callee!.rtcToken!, _authService.currentUser!.userId!);
      startCall();
    } catch (errorCode) {
      debugPrint("::::::::::::::$errorCode");
    }
  }

  // <----------------END RTM HANDLERS------------------> //

  // CHANGE SCREEN TO CALL SCREEN
  Future<void> startCall([User? u]) async {
    debugPrint("StartCall::::::::${args?.callMode}");
    try{
      if(u != null) {
        await initializeAgora(channelId.value, _authService.rtc!, _authService.currentUser!.userId!);
      }
      type.value = CallType.ongoing;
      await engine?.setEnableSpeakerphone(speakerOn());
    }
    catch(error) {
      debugPrint("Error::::::::$error");
    }
  }

  // END THE CALL ANY TIME
  void endCall() {
    RingtonePlayer.stop();
    Get.back();
  }

  // LEAVE RTC CHANNEL
  void endBroadcast() async {
    await engine?.leaveChannel();
  }

  // CHANGE CALL MODE
  void switchVideo() async {
    isVideo.value = !isVideo();

    if(isVideo()) {
      await engine?.enableLocalVideo(isVideo());
      await engine?.enableVideo();
      await engine?.startPreview();
    }
    else {
      await engine?.enableLocalVideo(isVideo());
      // await engine?.disableVideo();
      // await engine?.stopPreview();
    }
  }

  // TOGGLE MUTE
  void onToggleSpeaker() {
    speakerOn.value = !speakerOn();
    engine?.setEnableSpeakerphone(speakerOn());
  }

  // TOGGLE MIC
  void onToggleMic() {
    mic.value = !mic();
    engine?.muteLocalAudioStream(mic());
  }

  // SWITCH CAMERA
  void onSwitchCamera() async {
    await engine?.switchCamera();
  }
}