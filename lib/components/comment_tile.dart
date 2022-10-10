import 'package:flutter/material.dart';
import 'package:musedme/utils/app_colors.dart';

import '../models/chat.dart';
import '../widgets/text_widget.dart';

class CommentTile extends StatelessWidget {
  final ChatMessage chat;
  final Animation<double> animation;
  const CommentTile(this.chat, {Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> names = chat.uid.split("");
    return Align(
      alignment: Alignment.centerLeft,
      child: SizeTransition(
        sizeFactor: animation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  backgroundColor: AppColors.secondaryColor,
                  radius: 18,
                    child: TextWidget("${names[0]}${names[1]}".toUpperCase(), color: Colors.white),
                // backgroundImage: NetworkImage(Constants.albumArt)
              ),
              TextWidget("\t\t${chat.message}", weight: FontWeight.normal,),
            ],
          ),
        ),
      ),
    );
  }
}
