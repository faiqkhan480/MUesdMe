import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/widgets/glass_morphism.dart';

import '../components/comment_tile.dart';
import '../components/custom_scroll_view_content.dart';
import '../components/invitation_card.dart';
import '../models/chat.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_widget.dart';

class LiveScreen extends StatefulWidget {
  final String? channelName;
  final bool isBroadcaster;
  const LiveScreen({Key? key, this.channelName, this.isBroadcaster = true}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  TextEditingController chatController = TextEditingController();

  final _users = <int>[];
  bool muted = false;
  bool flash = false;
  bool loader = true;
  int? streamId;
  String userId = "abc";

  RtcEngine? _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  final List<Chat> _comments = [];
  // The key of the list
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk and leave channel
    _engine?.destroy();
    _channel?.leave();
    _client?.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();

    if (widget.isBroadcaster) streamId = await _engine!.createDataStream(false, false);

    _engine!.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          debugPrint('onJoinChannel: $channel, uid: $uid');
        });
      },
      leaveChannel: (stats) {
        setState(() {
          debugPrint('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          debugPrint('userJoined: $uid');

          _users.add(uid);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          debugPrint('userOffline: $uid');
          _users.remove(uid);
        });
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

    await _engine?.joinChannel(Constants.rtcToken, Constants.testChanel, null, 0);
  }

  // <----------------START RTC------------------> //
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(Constants.appId));
    _addListeners();
    await _engine!.enableVideo();

    await _engine!.startPreview();

    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine!.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine!.setClientRole(ClientRole.Audience);
    }

    _createClient();
  }

  void _addListeners() {
    _engine!.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        debugPrint('warning::::: $warningCode');
      },
      error: (errorCode) {
        debugPrint('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
        // setState(() {
        //   isJoined = true;
        // });
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined  $uid $elapsed');
        // setState(() {
        //   remoteUid.add(uid);
        // });
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline  $uid $reason');
        // setState(() {
        //   remoteUid.removeWhere((element) => element == uid);
        // });
      },
      leaveChannel: (stats) {
        debugPrint('leaveChannel ${stats.toJson()}');
        // setState(() {
        //   isJoined = false;
        //   remoteUid.clear();
        // });
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
      _comments.add(Chat(uid: peerId, message: message.text));
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
    debugPrint('Login :::::::::::::');
    try {
      await _client?.login(Constants.rtmToken, userId);
      setState(() => loader = false);
      _joinChannel();
    } catch (errorCode) {
      debugPrint('Login error:::: $errorCode');
    }
  }

  Future _joinChannel() async {
    try {
      _channel = await _createChannel(Constants.testChanel);
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
        _comments.insert(0, Chat(uid: member.userId, message: "Member joined: ${member.userId}"));
        _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        _comments.insert(0, Chat(uid: member.userId, message: "Member left: ${member.userId}"));
        _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
      };
      channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
        debugPrint(":::::::::::: RECIEVED MESSAGE");
        _comments.insert(0, Chat(uid: member.userId, message: message.text));
        _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
      };
    }
    return channel;
  }

  // <----------------END RTM------------------> //

  @override
  Widget build(BuildContext context) {
    debugPrint(":::::::::$_comments");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
              ),
              child: const Icon(CupertinoIcons.back, color: AppColors.secondaryColor,)
          ),
        ),
        title: Row(
          children: [
            badge("Live", true),
            const SizedBox(width: 10,),
            badge("3m views", false),
          ],
        ),
        actions: [
          FractionallySizedBox(
            heightFactor: .7,
            child: TextButton(
              onPressed: _onCallEnd,
              style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  // maximumSize: Size(100, 10),
                  minimumSize: const Size(100, 0),
                  textStyle: const TextStyle(fontSize: 12,
                      color: Colors.white,
                      fontFamily: Constants.fontFamily)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.iconsLive),
                  const SizedBox(width: 5,),
                  const Text("End Live"),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8,),
        ],
      ),

      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          // Container(
          //   color: Colors.amberAccent,
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          // ),
          _broadcastView(),

          if(loader)
            Lottie.asset(Assets.loader)
          else ...[
            _toolbar(),
            _commentsView(),
          ],
        ],
      ),

      bottomNavigationBar: InkWell(
        onTap: _handleBottomSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: Ink(
          decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor,
                    // spreadRadius: 3,
                    blurRadius: 5
                )
              ]
          ),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.iconsAdd, color: Colors.white),
                const SizedBox(width: 5,),
                const TextWidget("Invite People to Join live", color: Colors.white, weight: FontWeight.normal),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget badge(String text, bool live) {
    return Container(
      decoration: BoxDecoration(
        color: live ? AppColors.successColor : AppColors.secondaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: live ? TextWidget(text, color: Colors.white, weight: FontWeight.normal, size: 10) : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.iconsLive, height: 10),
          const SizedBox(width: 5,),
          TextWidget(text, color: Colors.white, weight: FontWeight.normal, size: 10),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Positioned(
      top: 100,
      right: -10,
      child: Column(
        children: [
          RawMaterialButton(
            onPressed: _onToggleFlash,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              flash ? Ionicons.ios_flash_sharp : Ionicons.ios_flash_outline,
              color: AppColors.lightGrey,
              size: 20.0,
            ),
          ),
          const SizedBox(height: 5,),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              MaterialCommunityIcons.reload,
              color: AppColors.lightGrey,
              size: 20.0,
            ),
          ),
          const SizedBox(height: 5,),
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Feather.volume_x : Feather.volume_2,
              color: AppColors.lightGrey,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentsView() {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Flexible(
                flex: 2,
                child: InvitationCard()),

            Flexible(
              flex: 4,
              child: AnimatedList(
                key: _key,
                  padding: const EdgeInsets.only(left: 20, right: 50),
                  reverse: true,
                  itemBuilder: (context, index, animation) => CommentTile(_comments.elementAt(index).message, animation: animation),
                  initialItemCount: _comments.length,
              ),
            ),

            // MESSAGE FIELD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: Row(
                children: [
                  Expanded(
                    child: GlassMorphism(
                      shape: BoxShape.rectangle,
                      child: TextField(
                        autofocus: false,
                        controller: chatController,
                        onSubmitted: (val) => _handleSubmit,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: _handleSubmit,
                              color: Colors.white,
                              iconSize: 30,
                              icon: const Icon(Icons.send,)
                          ),
                          hintText: 'Write your comment here...',
                          hintStyle: const TextStyle(color: Colors.white),
                          // isDense: true,
                          // fillColor: AppColors.textFieldColor,
                          // filled: true,
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.transparent)),
                        ),
                      ),
                    ),
                  ),

                  ButtonWidget(
                    onPressed: () => null,
                    text: "7.1k",
                    vertical: true,
                    textColor: Colors.white,
                    icon: Assets.iconsHeart,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    return widget.isBroadcaster
        ? Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onCallEnd,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          ),
        ],
      ),
    )
        : Container();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(const RtcLocalView.SurfaceView(channelId: "firstChannel",));
    }
    for (var uid in _users) {
      list.add(RtcRemoteView.SurfaceView(uid: uid, channelId: "firstChannel"));
    }
    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedViews = views.map<Widget>((view) => Expanded(child: Container(child: view))).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView([views[0]])
              ],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView([views[0]]),
                _expandedVideoView([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 3))],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
            ));
      default:
    }
    return Container();
  }

  void _onCallEnd() {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine!.muteLocalAudioStream(muted);
  }

  void _onToggleFlash() {
    setState(() {
      flash = !flash;
    });
    _engine!.setCameraTorchOn(flash);
  }

  void _onSwitchCamera() {
    List<int> list = "mute user blet".codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    if (streamId != null) _engine?.sendStreamMessage(streamId!, bytes);
    _engine!.switchCamera();
  }

  void _handleSubmit() async {
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

  void _handleBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CustomScrollViewContent();
      },
    );
  }
}
