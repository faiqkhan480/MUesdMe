import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/message_input.dart';
import '../components/message_tile.dart';
import '../controllers/message_controller.dart';
import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';


class MessageScreen extends GetView<MessageController> {
  const MessageScreen({Key? key}) : super(key: key);

  // User? get chatUser => controller.user.value;
  Chat? get _chatUser => controller.chat.value;
  List<Message?> get _messages => controller.messages;
  bool get _loading => controller.loading();
  AuthService get _authService => Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                badgeColor: AppColors.successColor,
                position: BadgePosition.topEnd(top: -1, end: 4),
                elevation: 0,
                borderSide: const BorderSide(color: Colors.white, width: .7),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    backgroundImage: NetworkImage(
                        _chatUser?.profilePic != null ?
                        Constants.IMAGE_URL + _chatUser!.profilePic! :
                        Constants.dummyImage
                    ),
                ),
              ),
            ),
            Text(_chatUser?.fullName ?? "", style: const TextStyle(fontFamily: Constants.fontFamily)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => null,
              icon: const Icon(Icons.info_outline_rounded, color: AppColors.lightGrey,)
          )
        ],
      ),
      body: Obx(() => Stack(
        children: [
          _loading && _messages.isEmpty ?
          const Loader() :
          ListView.builder(
            itemCount: _messages.length,
            // itemCount: controller.comments.length,
            physics: const BouncingScrollPhysics(),
            reverse: true,
            padding: const EdgeInsets.only(top: 10,bottom: 60),
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MessageTile(
                // message: controller.comments.elementAt(index),
                message: _messages.elementAt(index)!,
                senderImage: _authService.currentUser?.profilePic,
                receiverImage: _chatUser?.profilePic,
              );
            },
          ),

          if(!_loading)
            Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadowColor,
                        // spreadRadius: 3,
                        blurRadius: 5
                    )
                  ]
              ),
              height: 64,
              width: double.infinity,
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => null,
                          color: AppColors.primaryColor,
                          iconSize: 30,
                          icon: Image.asset(Assets.iconsSmileyFace)
                      ),
                      Expanded(child: MessageInput(controller.message)),
                      const SizedBox(width: 5,),
                      IconButton(
                          onPressed: controller.sendMessage,
                          color: AppColors.primaryColor,
                          iconSize: 30,
                          icon: const Icon(Icons.send,)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
      ),),
    );
  }
}

