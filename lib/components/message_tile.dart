import 'package:flutter/material.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../screens/chat_screen.dart';
import '../utils/app_colors.dart';

class MessageTile extends StatelessWidget {
  final ChatMessage message;
  const MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: (message.messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (
                message.messageType  == "receiver" ?
                const Color(0xFFF2F2F2) :
                AppColors.primaryColor
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: TextWidget(message.messageContent,
            size: 15,
            color: message.messageType  == "receiver" ? Colors.black : Colors.white,
            weight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
