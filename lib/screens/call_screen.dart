import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import '../controllers/call_controller.dart';
import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';
import '../widgets/text_widget.dart';

class CallScreen extends GetView<CallController> {
  const CallScreen({Key? key}) : super(key: key);

  User? get chatUser => controller.user.value;
  AuthService get _authService => Get.find<AuthService>();
  CallType get _type => controller.type.value;
  int? get _remoteUid => controller.remoteUid.value;
  String get channelId => controller.channelId.value;
  bool get _localUserJoined => controller.localUserJoined.value;
  RtcEngine? get client => controller.engine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
      _type == CallType.ongoing ?
        SafeArea(
        child: Stack(
          children: [
            Center(
              child: _renderRemoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: _renderLocalPreview(),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: controller.switchVideo,
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: AppColors.blue,
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(CupertinoIcons.video_camera_solid,
                        color: Colors.white,
                        size: 34.0,
                      ),
                    ),
                    SizedBox(width: 20,),
                    RawMaterialButton(
                      onPressed: controller.endBroadcast,
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: AppColors.orange,
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(CupertinoIcons.phone_down,
                        color: Colors.white,
                        size: 34.0,
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ) :
        Container(
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
      )
      ),
    );
  }
  // current user video
  Widget _renderLocalPreview() {
    debugPrint("LOCAL USER :::::::::: ${_localUserJoined}");
    if (_localUserJoined) {
      return RtcLocalView.SurfaceView(channelId: channelId);
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  // remote user video
  Widget _renderRemoteVideo() {
    debugPrint("_remoteUid :::::::::: ${_remoteUid}");
    debugPrint("_Channel Name :::::::::: ${channelId}");
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!, channelId: channelId,);
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
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
