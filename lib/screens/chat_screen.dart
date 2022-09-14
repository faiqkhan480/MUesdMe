import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/message_input.dart';
import '../components/message_tile.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';

final List<ChatMessage> messages = [
  ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
  ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
];

class ChatScreen extends StatelessWidget {
  final String title;
  const ChatScreen({Key? key, required this.title}) : super(key: key);

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
                child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    backgroundImage: NetworkImage(Constants.dummyImage)),
              ),
            ),
            Text(title, style: const TextStyle(fontFamily: Constants.fontFamily)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => null,
              icon: const Icon(Icons.info_outline_rounded, color: AppColors.lightGrey,)
          )
        ],
      ),

      body: ListView.builder(
        itemCount: messages.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => MessageTile(message: messages.elementAt(index)),
      ),

      bottomSheet: Container(
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
                const Expanded(child: MessageInput()),
                const SizedBox(width: 5,),
                IconButton(
                    onPressed: () => null,
                    color: AppColors.primaryColor,
                    iconSize: 30,
                    icon: const Icon(Icons.send,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

