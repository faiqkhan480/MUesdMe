import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musedme/controllers/agora_controller.dart';

import '../models/chat.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class LiveController extends GetxController {
  RtcEngine? engine;

  TextEditingController chatController = TextEditingController();

  final AuthService _service = Get.find<AuthService>();

  final AgoraRtmClient? _client = Get.find<AgoraController>().client;
  AgoraRtmChannel? _channel;

  RxList<int> users = <int>[].obs;
  RxInt views = 0.obs;
  RxBool muted = false.obs;
  RxBool flash = false.obs;
  RxBool loading = true.obs;

  RxBool isBroadcaster = true.obs;
  int? streamId;
  // String userId = "abc";

  RxList<ChatMessage?> comments = List<ChatMessage?>.empty(growable: true).obs;
  // The key of the list
  final GlobalKey<AnimatedListState> key = GlobalKey();

  var args = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(args != null) {
      isBroadcaster.value = args["isBroadcaster"];
    }
    initializeAgora();
  }

  @override
  void onClose() {
    // clear users
    users.clear();
    // destroy sdk and leave channel
    engine?.destroy();
    _channel?.leave();
    // _client?.destroy();
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();

    if (args["isBroadcaster"]) streamId = await engine!.createDataStream(false, false);

    engine!.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('onJoinChannel: $channel, uid: $uid');
      },
      leaveChannel: (stats) {
        debugPrint('onLeaveChannel');
        users.clear();
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined: $uid');
        users.add(uid);
      },
      userOffline: (uid, elapsed) {
        debugPrint('userOffline: $uid');
        users.remove(uid);
      },
      streamMessage: (_, __, message) {
        final String info = "here is the message $message";
        debugPrint(info);
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        debugPrint(info);
      },
    ));

    await engine?.joinChannel(_service.rtc, "${Constants.agoraBaseId}${_service.currentUser?.userId}", null, 0);

    await _joinChannel();
  }

  // <----------------START RTC------------------> //
  Future<void> _initAgoraRtcEngine() async {
    engine = await RtcEngine.createWithContext(RtcEngineContext(Constants.appId));
    _addListeners();
    await engine!.enableVideo();

    await engine!.startPreview();

    await engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (args["isBroadcaster"]) {
      await engine!.setClientRole(ClientRole.Broadcaster);
    } else {
      await engine!.setClientRole(ClientRole.Audience);
    }
  }

  void _addListeners() {
    engine!.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        debugPrint('warning::::: $warningCode');
      },
      error: (errorCode) {
        debugPrint('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
        //   isJoined = true;
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined  $uid $elapsed');
        //   remoteUid.add(uid);
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline  $uid $reason');
        //   remoteUid.removeWhere((element) => element == uid);
      },
      leaveChannel: (stats) {
        debugPrint('leaveChannel ${stats.toJson()}');
        //   isJoined = false;
        //   remoteUid.clear();
      },
    ));
  }

  // <----------------END RTC------------------> //

  // <----------------START RTM CHANNEL------------------> //
  Future _joinChannel() async {
    try {
      _channel = await _createChannel("${Constants.agoraBaseId}${_service.currentUser?.userId}");
      debugPrint('Join channel success. ${Constants.agoraBaseId}${_service.currentUser?.userId}');
      await _channel?.join();
      if(kDebugMode) {
        Get.snackbar("Success", "Join channel success.", backgroundColor: AppColors.successColor, colorText: Colors.white);
      }
      loading.value = false;
    } catch (errorCode) {
      debugPrint('Join channel error: $errorCode');
      if(kDebugMode) {
        Get.snackbar("Join channel error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if(channel != null) {
      channel.onMemberJoined = (AgoraRtmMember member) {
        if(kDebugMode) {
          Get.snackbar("Member joined", member.userId.toString(), backgroundColor: AppColors.successColor, colorText: Colors.white);
        }
        debugPrint('Member joined: ${member.userId}');
        views.value = views.value+1;
        comments.insert(0, ChatMessage(uid: member.userId, message: "Member joined: ${member.userId}"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
        update();
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        views.value = views.value-1;
        comments.insert(0, ChatMessage(uid: member.userId, message: "Member left: ${member.userId}"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
      };
      channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
        // if(kDebugMode) {
        //   Get.snackbar("Received Message", message.text.toString(), backgroundColor: AppColors.successColor, colorText: Colors.white);
        // }
        views.value = views.value+1;
        debugPrint(":::::::::::: RECEIVED MESSAGE");
        comments.insert(0, ChatMessage(uid: member.userId, message: message.text, type: "receiver"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
        update();
      };
    }
    return channel;
  }

  // <----------------END RTM------------------> //

  void onCallEnd() {
    Get.back();
  }

  void onToggleMute() {
    muted.value = !muted();
    engine!.muteLocalAudioStream(muted());
  }

  void onToggleFlash() {
    flash.value = !flash();
    engine!.setCameraTorchOn(flash());
  }

  void onSwitchCamera() {
    List<int> list = "mute user blet".codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    if (streamId != null) engine?.sendStreamMessage(streamId!, bytes);
    engine!.switchCamera();
  }

  void handleSubmit([String? val]) async {
    String text = chatController.text;
    debugPrint(":::::::::::${text}");
    if (text.isNotEmpty) {
      try {
        await _channel?.sendMessage(AgoraRtmMessage.fromText(text));
        comments.insert(0, ChatMessage(uid: "${Constants.agoraBaseId}${_service.currentUser?.userId}", message: text, type: "receiver"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
        chatController.clear();
      } catch (errorCode) {
        debugPrint("Send channel message error: $errorCode");
        if(kDebugMode) {
          Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    }
  }
}