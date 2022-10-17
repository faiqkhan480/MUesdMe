import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/services/auth_service.dart';

import '../components/comment_tile.dart';
import '../components/users_sheet.dart';
import '../components/invitation_card.dart';
import '../controllers/feed_controller.dart';
import '../controllers/live_controller.dart';
import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/text_widget.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({Key? key}) : super(key: key);

  User get _currUser => Get.find<AuthService>().currentUser!;
  LiveController get _controller => Get.find<LiveController>();
  List<User?> get users => Get.find<FeedController>().users;
  int get views => _controller.views();
  List<ChatMessage?> get comments => _controller.comments;
  bool get isBroadcaster => _controller.isBroadcaster();
  bool get loading => _controller.loading();
  bool get flashSupported => _controller.flashSupported();
  bool get flash => _controller.flash();
  bool get muted => _controller.muted();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: _controller.onCallEnd,
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
        title: (_controller.isBroadcaster()) ? Row(
          children: [
            badge("Live", true),
            const SizedBox(width: 10,),
            Obx(() => badge("$views views", false)),
          ],
        ) : null,
        actions: [
          FractionallySizedBox(
            heightFactor: .7,
            child: TextButton(
              onPressed: _controller.onCallEnd,
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

      body: Obx(() => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          _broadcastView(),

          if(_controller.loading())
            Lottie.asset(Assets.loader)
          else ...[
            _toolbar(),
            _commentsView(),
          ],
        ],
      )),

      bottomNavigationBar: InkWell(
        onTap: _handleBottomSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: Container(
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
          Obx(() => (flashSupported) ?
          RawMaterialButton(
      onPressed: _controller.onToggleFlash,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(12.0),
      child: Icon(
        flash ? Ionicons.ios_flash_sharp : Ionicons.ios_flash_outline,
        color: AppColors.lightGrey,
        size: 20.0,
      ),
    ) :
          const SizedBox.shrink()),
          const SizedBox(height: 5,),
          RawMaterialButton(
            onPressed: _controller.onSwitchCamera,
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
            onPressed: _controller.onToggleMute,
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
        height: Get.height * .5,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const Flexible(
            //     flex: 2,
            //     child: InvitationCard()),

            Flexible(
              flex: 4,
              child: AnimatedList(
                key: _controller.key,
                  padding: const EdgeInsets.only(left: 20, right: 50),
                  reverse: true,
                  itemBuilder: (context, index, animation) => CommentTile(
                      user: users.firstWhere((u) => u?.userId.toString() == comments.elementAt(index)?.uid.replaceAll(Constants.agoraBaseId, ""),
                        orElse: () => _currUser,),
                      comments.elementAt(index)!,
                      animation: animation
                  ),
                  initialItemCount: comments.length,
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
                        controller: _controller.chatController,
                        onSubmitted: _controller.handleSubmit,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: _controller.handleSubmit,
                              color: Colors.white,
                              iconSize: 30,
                              icon: const Icon(Icons.send,)
                          ),
                          hintText: 'Write your message here...',
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

                  // ButtonWidget(
                  //   onPressed: () => null,
                  //   text: "0",
                  //   vertical: true,
                  //   textColor: Colors.white,
                  //   icon: Assets.iconsHeart,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (isBroadcaster) {
      list.add(RtcLocalView.SurfaceView(channelId: "${Constants.agoraBaseId}${_currUser.userId!}"));
    }
    for (var uid in _controller.users) {
      // broadcaster
        list.add(RtcRemoteView.SurfaceView(uid: uid, channelId: "${Constants.agoraBaseId}${_controller.broadcaster?.userId ?? _currUser.userId!}"));
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
      default:
    }
    return const SizedBox.shrink();
  }

  void _handleBottomSheet() {
    Get.bottomSheet(
        const UsersSheet(),
        backgroundColor: Colors.transparent,
    );
  }
}
