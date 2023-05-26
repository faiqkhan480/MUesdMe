
import 'package:badges/badges.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../components/invitation_card.dart';
import '../../components/message_input.dart';
import '../../components/message_tile.dart';
import '../../controllers/message_controller.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/style_config.dart';
import '../../widgets/loader.dart';


class MessageScreen extends GetView<MessageController> {
  const MessageScreen({Key? key}) : super(key: key);

  // User? get chatUser => controller.user.value;
  Chat? get _chatUser => controller.chat.value;
  List<Message?> get _messages => controller.messages;
  bool get _loading => controller.loading();
  bool get _fetching => controller.fetching();
  AuthService get _authService => Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () => Get.back(),
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
            Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                badgeColor: controller.isOnline() ? AppColors.successColor : AppColors.lightGrey,
                position: BadgePosition.topEnd(top: -1, end: 4),
                elevation: 0,
                borderSide: const BorderSide(color: Colors.white, width: .7),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    backgroundImage: NetworkImage(
                        _chatUser?.profilePic != null && _chatUser!.profilePic!.isNotEmpty ?
                        Constants.IMAGE_URL + _chatUser!.profilePic! :
                        Constants.dummyImage
                    ),
                ),
              ),
            )),
            Text(_chatUser?.fullName ?? "",
                style: const TextStyle(fontFamily: Constants.fontFamily)),
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
          GroupedListView<Message?, DateTime?>(
            padding: const EdgeInsets.only(top: 10,bottom: 60),
            elements: _messages,
            groupBy: (element) {
              if(element?.type == "Invite"){
                if(element?.userId != _authService.currentUser?.userId) {
                  return DateTime(element!.messageDate!.year, element.messageDate!.month, element.messageDate!.day);
                }
                return DateTime(element!.messageDate!.year, element.messageDate!.month, element.messageDate!.day, 1);
              }
              return DateTime(element!.messageDate!.year, element.messageDate!.month, element.messageDate!.day);
            },
            groupSeparatorBuilder: (DateTime? groupByValue) => (groupByValue == null || groupByValue.hour == 1) ?
            const SizedBox.shrink() :
            Center(child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.all(8),
                child: Text(DateFormat("dd MMM yyyy").format(groupByValue), style: const TextStyle(color: Colors.white),),
              ),),
            // itemBuilder: (context, dynamic element) => Text(element['name']),
            itemBuilder: (context, element) {
              if(element?.chatId != _chatUser?.chatId){
                return const SizedBox.shrink();
              }
              if(element?.type == "Invite"){
                if(element?.userId != _authService.currentUser?.userId) {
                  return Center(
                    child: InvitationCard(user: _chatUser, onTap: () => controller.handleInvite(element!),),
                  );
                }
                return const SizedBox.shrink();
              }
              return MessageTile(
                message: element!,
                senderImage: _authService.currentUser?.profilePic,
                receiverImage: _chatUser?.profilePic,
              );
            },
            itemComparator: (item1, item2) => (item1 != null && item2 != null) ? item1.messageDate!.compareTo(item2.messageDate!) : 0, // optional
            useStickyGroupSeparators: false, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.DESC, // optional
            physics: const BouncingScrollPhysics(),
            reverse: true,
          ),
          // ListView.builder(
          //   itemCount: _messages.length,
          //   physics: const BouncingScrollPhysics(),
          //   reverse: true,
          //   padding: const EdgeInsets.only(top: 10,bottom: 60),
          //   // physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     if(_messages.elementAt(index)?.chatId != _chatUser?.chatId){
          //       return const SizedBox.shrink();
          //     }
          //     if(_messages.elementAt(index)?.type == "Invite"){
          //       if(_messages.elementAt(index)?.userId != _authService.currentUser?.userId) {
          //         return Center(
          //           child: InvitationCard(user: _chatUser, onTap: () => controller.handleInvite(_messages.elementAt(index)!),),
          //         );
          //       }
          //       return const SizedBox.shrink();
          //     }
          //     return MessageTile(
          //       message: _messages.elementAt(index)!,
          //       senderImage: _authService.currentUser?.profilePic,
          //       receiverImage: _chatUser?.profilePic,
          //     );
          //   },
          // ),

          if(!_loading)...[
            Offstage(
              offstage: !controller.emojiShowing(),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: controller.message,
                      onBackspacePressed: controller.onPressed,
                      config: StyleConfig.emojiConfig,
                    )),
              ),
            ),
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
                      // IconButton(
                      //     onPressed: controller.onPressed,
                      //     color: AppColors.primaryColor,
                      //     iconSize: 30,
                      //     icon: Image.asset(Assets.iconsSmileyFace)
                      // ),
                      Expanded(child: MessageInput(controller.message)),
                      const SizedBox(width: 5,),

                      _fetching ?
                      const Center(child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 2,)) :
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
          ],
        ]
      ),),
    );
  }
}

