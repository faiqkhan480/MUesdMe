import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import '../controllers/call_controller.dart';
import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';
import '../widgets/text_widget.dart';

class CallScreen extends GetView<CallController> {
  const CallScreen({Key? key}) : super(key: key);

  User? get chatUser => controller.user.value;

  CallType get _type => controller.type.value;
  List get _users => controller.users;
  String get channelId => controller.channelId.value;
  bool get _localUserJoined => controller.localUserJoined.value;
  RtcEngine? get client => controller.engine;

  bool get mic => controller.mic.value;
  bool get speakerOn => controller.speakerOn.value;
  bool get isVideo => controller.isVideo.value;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
      _type == CallType.ongoing ?
        SafeArea(
        child: Stack(
          children: [
            _broadcastView(),

            _vertToolbar(),

            _toolbar()
          ],
        ),
      ) :
        _body(),
      ),
    );
  }

  Widget _body() {
    return SizedBox(
      // color: AppColors.secondaryColor.withOpacity(0.4),
      // decoration: StyleConfig.gradientBackground,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 20, right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if(_type == CallType.incoming)
                  const CircleLoader(),

                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 80,
                  backgroundImage: NetworkImage(
                      chatUser?.profilePic != null && chatUser!.profilePic!.isNotEmpty?
                      Constants.IMAGE_URL + chatUser!.profilePic! :
                      Constants.dummyImage
                  ),
                ),
              ],
            ),
            // const Spacer(),
            Column(
              children: [
                TextWidget(
                  "\n${chatUser?.firstName?.capitalize} ${chatUser?.lastName?.capitalize}\n",
                  size: Get.textScaleFactor * 35,
                ),
                TextWidget(
                  "Calling...",
                  color: AppColors.lightGrey,
                  size: Get.textScaleFactor * 25,
                ),
              ],
            ),

            // const Spacer(),

            // SizedBox.shrink(),

            if(_type == CallType.outgoing)
              const SizedBox(
                height: 60,
                child: CallLoader(),
              )
            else
              const Spacer(),

            Flexible(
              child: Row(
                children: [
                  Expanded(child: TextButton(
                    onPressed: controller.endCall,
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(CupertinoIcons.phone_down, color: Colors.white,),
                        // SvgPicture.asset(Assets.iconsDelete),
                        // const SizedBox(width: 5,),
                        // TextWidget(_type == CallType.outgoing ? "End Call" : "Accept Call", weight: FontWeight.w500, size: 18, color: Colors.white),
                      ],
                    ),
                  )),
                  if(_type == CallType.incoming) ...[
                    const SizedBox(width: 10,),
                    Expanded(child: TextButton(
                      onPressed: controller.acceptCallInvite,
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.successColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                          textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                      ),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.phone, color: Colors.white,),
                          // SvgPicture.asset(Assets.iconsDelete),
                          // const SizedBox(width: 5,),
                          // TextWidget(_type == CallType.outgoing ? "End Call" : "Accept Call", weight: FontWeight.w500, size: 18, color: Colors.white),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // current user video
  // Widget _renderLocalPreview() {
  //   if (_localUserJoined) {
  //     return RtcLocalView.SurfaceView(channelId: channelId);
  //   } else {
  //     return const Text(
  //       'Please join channel first',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }
  //
  // // remote user video
  // Widget _renderRemoteVideo() {
  //   if (_remoteUid != 0) {
  //     return RtcRemoteView.SurfaceView(uid: _remoteUid!, channelId: channelId,);
  //   } else {
  //     return Padding(
  //       padding: const EdgeInsets.only(top: 50.0, bottom: 20, right: 20, left: 20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           CircleAvatar(
  //             backgroundColor: Colors.white,
  //             radius: 80,
  //             backgroundImage: NetworkImage(
  //                 chatUser?.profilePic != null && chatUser!.profilePic!.isNotEmpty?
  //                 Constants.IMAGE_URL + chatUser!.profilePic! :
  //                 Constants.dummyImage
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //     // return const Text(
  //     //   'Please wait remote user join',
  //     //   textAlign: TextAlign.center,
  //     // );
  //   }


  Widget _vertToolbar() {
    return Positioned(
      top: 50,
      right: -10,
      child: Column(
        children: [
          RawMaterialButton(
            onPressed: controller.onToggleMic,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              mic ? Feather.mic_off : Feather.mic,
              color: AppColors.lightGrey,
              size: 20.0,
            ),
          ),
          const SizedBox(height: 5,),
          RawMaterialButton(
            onPressed: controller.onSwitchCamera,
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
            onPressed: controller.onToggleSpeaker,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              speakerOn ? Feather.volume_x : Feather.volume_2,
              color: AppColors.lightGrey,
              size: 20.0,
            ),
          ),
          const SizedBox(height: 5,),
          RawMaterialButton(
            onPressed: controller.switchVideo,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              isVideo ? Feather.video : Feather.video_off,
              color: AppColors.lightGrey,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Positioned(
        left: Get.width * 0.30,
        right: Get.width * 0.30,
        bottom: 30,
        child: TextButton(
          onPressed: controller.endCall,
          style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(CupertinoIcons.phone_down, color: Colors.white,),
              // SvgPicture.asset(Assets.iconsDelete),
              // const SizedBox(width: 5,),
              // TextWidget(_type == CallType.outgoing ? "End Call" : "Accept Call", weight: FontWeight.w500, size: 18, color: Colors.white),
            ],
          ),
        ),
        // child: RawMaterialButton(
        //   onPressed: controller.endBroadcast,
        //   shape: const CircleBorder(),
        //   elevation: 2.0,
        //   fillColor: AppColors.orange,
        //   padding: const EdgeInsets.all(15.0),
        //   child: const Icon(Feather.phone,
        //     color: Colors.white,
        //     size: 20.0,
        //   ),
        // ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[
            _expandedVideoView([views[0]])
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoView([views[0]]),
            _expandedVideoView([views[1]])
          ],
        );
      case 3:
        return Column(
          children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 3))],
        );
      case 4:
        return Column(
          children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
        );
      case 5:
        return Column(
          children: <Widget>[
            _expandedVideoView(views.sublist(1, 2)),
            _expandedVideoView(views.sublist(2, 4)),
            _expandedVideoView(views.sublist(0, 1)),
          ],
        );
      case 6:
        return Column(
          children: <Widget>[
            _expandedVideoView(views.sublist(1, 2)),
            _expandedVideoView(views.sublist(2, 4)),
            _expandedVideoView(views.sublist(0, 1)),
          ],
        );
        // return Column(
        //   children: List.generate(views.length, (index) {
        //     if( (index % 2 == 0)) {
        //       debugPrint("VIEW1::: ${(index+1)-2}");
        //       debugPrint("VIEW2::: ${index+1}");
        //       return _expandedVideoView(views.sublist((index+1)-2, (index+1)));
        //     }
        //     return _expandedVideoView([views[index]]);
        //     // return const SizedBox.shrink();
        //   }),
        // );
      default:
      //   return Column(
      //     children: List.generate(views.length, (index) => index > 0 && (index % 2 == 0) ? _expandedVideoView(views.sublist(index-2, index)) : const SizedBox.shrink()),
      //     // children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
      //   );
    }
    return const SizedBox.shrink();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (_localUserJoined) {
      list.add(RtcLocalView.SurfaceView(channelId: channelId));
    }
    for (var uid in _users) {
      // broadcaster
      list.add(RtcRemoteView.SurfaceView(uid: uid, channelId: channelId));
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

  // /// Helper function to get list of native views
  // List<Widget> _getRenderViews() {
  //   final List<StatefulWidget> list = [];
  //   if (isBroadcaster) {
  //     list.add(RtcLocalView.SurfaceView(channelId: "${Constants.agoraBaseId}${_currUser.userId!}"));
  //   }
  //   for (var uid in _controller.users) {
  //     // broadcaster
  //     list.add(RtcRemoteView.SurfaceView(uid: uid, channelId: "${Constants.agoraBaseId}${_controller.broadcaster?.userId ?? _currUser.userId!}"));
  //   }
  //   return list;
  // }
  //
  // /// Video view row wrapper
  // Widget _expandedVideoView(List<Widget> views) {
  //   final wrappedViews = views.map<Widget>((view) => Expanded(child: Container(child: view))).toList();
  //   return Expanded(
  //     child: Row(
  //       children: wrappedViews,
  //     ),
  //   );
  // }
  //
  // /// Video layout wrapper
  // Widget _broadcastView() {
  //   final views = _getRenderViews();
  //   switch (views.length) {
  //     case 1:
  //       return Column(
  //         children: <Widget>[
  //           _expandedVideoView([views[0]])
  //         ],
  //       );
  //     case 2:
  //       return Column(
  //         children: <Widget>[
  //           _expandedVideoView([views[0]]),
  //           _expandedVideoView([views[1]])
  //         ],
  //       );
  //     case 3:
  //       return Column(
  //         children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 3))],
  //       );
  //     case 4:
  //       return Column(
  //         children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
  //       );
  //     default:
  //   }
  //   return const SizedBox.shrink();
  // }
}
