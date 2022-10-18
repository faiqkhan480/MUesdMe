import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musedme/controllers/agora_controller.dart';

import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'feed_controller.dart';

class LiveController extends GetxController {
  RtcEngine? engine;

  TextEditingController chatController = TextEditingController();

  final AuthService _service = Get.find<AuthService>();
  final ApiService _apiService = Get.find<ApiService>();

  final AgoraRtmClient? _client = Get.find<AgoraController>().client;
  final List<User?> _users = Get.find<FeedController>().users;
  AgoraRtmChannel? _channel;

  RxList<int> users = <int>[].obs;
  RxInt views = 0.obs;
  RxBool muted = false.obs;
  RxBool flash = false.obs;
  RxBool flashSupported = false.obs;
  RxBool loading = true.obs;

  User? broadcaster;
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
      broadcaster = args['broadcaster'];
    }
    initializeAgora();
  }

  @override
  void onClose() {
    _apiService.goLive(false);
    // clear users
    users.clear();
    // destroy sdk and leave channel
    engine?.destroy();
    _channel?.leave();
    // _client?.destroy();
    // TODO: implement onClose
    super.onClose();
  }

  // Push Live status
  Future<void> updateLiveStatus({bool? d}) async {
    var res = await _apiService.goLive(d ?? isBroadcaster());
    if(res != true) {
      users.clear();
      // destroy sdk and leave channel
      engine?.destroy();
      _channel?.leave();
      Get.back();
      Get.snackbar("Failed!", "Enable to go live!",
          backgroundColor: AppColors.pinkColor,
          colorText: Colors.white
      );
    }
  }

  Future<void> initializeAgora() async {
    String rtcToken = args["isBroadcaster"] && broadcaster == null ? _service.rtc! : broadcaster!.rtcToken!;
    String channelName = args["isBroadcaster"] && broadcaster == null ?
    "${Constants.agoraBaseId}${_service.currentUser?.userId}" :
    "${Constants.agoraBaseId}${broadcaster!.userId!}";
    // int uid = args["isBroadcaster"] ? _service.currentUser!.userId! : broadcaster!.userId!;
    int uid = _service.currentUser!.userId!;
    await _initAgoraRtcEngine();

    if (args["isBroadcaster"]) streamId = await engine?.createDataStream(false, false);


    await engine?.joinChannel(rtcToken, channelName, null, uid);

    await _joinChannel();

    if(args["isBroadcaster"]) {
      await updateLiveStatus();
    }
  }

  // <----------------START RTC------------------> //
  Future<void> _initAgoraRtcEngine() async {
    // engine = await RtcEngine.createWithContext(RtcEngineContext(Constants.appId));
    engine = await RtcEngine.create(Constants.appId);
    _addListeners();
    await engine?.enableVideo();

    await engine?.startPreview();

    bool? suported = await engine?.isCameraTorchSupported();
    flashSupported.value = suported ?? false;

    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (args["isBroadcaster"]) {
      await engine?.setClientRole(ClientRole.Broadcaster);
    } else {
      await engine?.setClientRole(ClientRole.Audience);
    }
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
        //   isJoined = true;
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined RTC::::::::: $uid $elapsed');
        users.add(uid);
        update();
        //   remoteUid.add(uid);
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline  $uid $reason');
        users.removeWhere((element) => element == uid);
        update();
        if(uid == broadcaster?.userId) {
          Get.back();
          Get.snackbar("Broadcast is Finished!", "User end the broadcast!",
              backgroundColor: AppColors.blue,
              colorText: Colors.white
          );
        }
      },
      leaveChannel: (stats) {
        debugPrint('RTC leaveChannel ${stats.toJson()}');
          // isJoined = false;
        users.clear();
      },
    ));
  }

  // <----------------END RTC------------------> //

  // <----------------START RTM CHANNEL------------------> //
  Future _joinChannel() async {
    try {
      String _channedId = args["isBroadcaster"] ? "${Constants.agoraBaseId}${_service.currentUser?.userId}" : "${Constants.agoraBaseId}${broadcaster!.userId!}";
      _channel = await _createChannel(_channedId);
      debugPrint('Join channel success. ${_channedId}');
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
          Get.snackbar("Member joined", getUsername(member.userId)!, backgroundColor: AppColors.successColor, colorText: Colors.white);
        }
        // debugPrint('Member joined: ${member.userId}');
        views.value = views.value+1;
        comments.insert(0, ChatMessage(uid: member.userId, message: "Member joined: ${getUsername(member.userId)}"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
        update();
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        views.value = views.value-1;
        comments.insert(0, ChatMessage(uid: member.userId, message: "Member left: ${getUsername(member.userId)}"));
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
    engine?.muteLocalAudioStream(muted());
    for (var uid in users) {
      engine?.muteRemoteAudioStream(uid, muted());
    }
  }

  void onToggleFlash() {
    flash.value = !flash();
    engine?.setCameraTorchOn(flash());

  }

  void onSwitchCamera() async {
    // List<int> list = "mute user blet".codeUnits;
    // Uint8List bytes = Uint8List.fromList(list);
    // // if (streamId != null) engine?.sendStreamMessage(streamId!, bytes);
    await engine?.switchCamera();
    // bool? supported = await engine?.isCameraTorchSupported();
    // debugPrint("::::::::::: $supported");
    flashSupported.value = !flashSupported.value;
  }

  void handleSubmit([String? val]) async {
    String text = chatController.text;
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

  String getId(String text) {
    return text.replaceAll(Constants.agoraBaseId, "");
  }

  String? getUsername(String uid) {
    int id = int.parse(getId(uid));
    return _users.firstWhereOrNull((u) => u?.userId == id)?.userName;
  }
}