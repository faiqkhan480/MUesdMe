import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musedme/services/auth_service.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../screens/message_screen.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class MessageTile extends StatelessWidget {
  // final ChatMessage message;
  final Message message;
  final String? senderImage;
  final String? receiverImage;
  const MessageTile({Key? key, required this.message, this.senderImage, this.receiverImage}) : super(key: key);

  AuthService get _auth => Get.find<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: (message.userId == _auth.currentUser?.userId ? MainAxisAlignment.start : MainAxisAlignment.end),
          children: [
            if(message.userId == _auth.currentUser?.userId)
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28,
                backgroundImage: NetworkImage(
                    receiverImage != null && receiverImage!.isNotEmpty ?
                    Constants.IMAGE_URL + receiverImage! :
                    Constants.dummyImage
                ),),
                // backgroundImage: NetworkImage(
                //     Constants.IMAGE_URL + receiverImage)),
            if(message.userId != _auth.currentUser?.userId)
              const SizedBox(width: 30,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (
                      message.userId == _auth.currentUser?.userId ?
                      const Color(0xFFF2F2F2) :
                      AppColors.primaryColor
                  ),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextWidget(message.message ?? "",
                  size: 15,
                  color: message.userId == _auth.currentUser?.userId ? Colors.black : Colors.white,
                  weight: FontWeight.normal,
                ),
              ),
            ),
            if(message.userId == _auth.currentUser?.userId)
              const SizedBox(width: 30,),
            if(message.userId != _auth.currentUser?.userId)
               CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  backgroundImage: NetworkImage(
                      senderImage != null && senderImage!.isNotEmpty ?
                      Constants.IMAGE_URL + senderImage! :
                      Constants.dummyImage
                  )),
          ],
        ),
    );
  }
}
