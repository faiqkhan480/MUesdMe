import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/chat.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class LiveController extends GetxController {
  RtcEngine? engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  TextEditingController chatController = TextEditingController();

  final AuthService _service = Get.find<AuthService>();

  RxList<int> users = <int>[].obs;
  RxBool muted = false.obs;
  RxBool flash = false.obs;
  RxBool loading = true.obs;

  RxBool isBroadcaster = true.obs;
  int? streamId;
  // String userId = "abc";

  RxList comments = [].obs;
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
    _client?.destroy();
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

    await engine?.joinChannel(_service.rtc, "MusedByMe_${_service.currentUser?.userId}", null, 0);
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

    _createClient();
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

  // <----------------START RTM------------------> //
  Future _createClient() async {
    _client = await AgoraRtmClient.createInstance(Constants.appId);
    debugPrint("RTM Initialize::::::::");

    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      // logController.addLog("Private Message from " + peerId + ": " + message.text);
      comments.add(ChatMessage(uid: peerId, message: message.text, type: "receiver"));
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      debugPrint('Connection state changed::::::::::: $state, reason: $reason');
      if (state == 5) {
        _client?.logout();
        // logController.addLog('Logout.');
      }
    };
    _login();
  }

  Future _login() async {
    try {
      await _client?.login(_service.rtm, "MusedByMe_${_service.currentUser?.userId}");
      loading.value = false;
      Get.snackbar("Success", "Login success!", backgroundColor: Colors.green, colorText: Colors.white);
      _joinChannel();
    } catch (errorCode) {
      debugPrint('Login error:::: $errorCode');
      Get.snackbar("Error", errorCode.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future _joinChannel() async {
    try {
      _channel = await _createChannel("MusedByMe_${_service.currentUser?.userId}");
      debugPrint('Join channel success.');
      await _channel?.join();
      // logController.addLog('Join channel success.');
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MessageScreen(
      //           client: _client,
      //           channel: _channel,
      //           logController: logController,
      //         )));
    } catch (errorCode) {
      debugPrint('Join channel error: $errorCode');
    }
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if(channel != null) {
      channel.onMemberJoined = (AgoraRtmMember member) {
        comments.insert(0, ChatMessage(uid: member.userId, message: "Member joined: ${member.userId}"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        comments.insert(0, ChatMessage(uid: member.userId, message: "Member left: ${member.userId}"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
      };
      channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
        debugPrint(":::::::::::: RECIEVED MESSAGE");
        comments.insert(0, ChatMessage(uid: member.userId, message: message.text, type: "receiver"));
        key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
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
    if (text.isNotEmpty) {
      try {
        await _channel?.sendMessage(AgoraRtmMessage.fromText(text));
      } catch (errorCode) {
        debugPrint("Send channel message error: $errorCode");
        // widget.logController.addLog('Send channel message error: ' + errorCode.toString());
      }
    }
  }
}