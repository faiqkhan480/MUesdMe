import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class CommentTile extends StatelessWidget {
  final String text;
  final Animation<double> animation;
  const CommentTile(this.text, {Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  backgroundImage: NetworkImage(Constants.albumArt)),
              TextWidget("\t\t$text", weight: FontWeight.normal,),
            ],
          ),
        ),
      ),
    );
  }
}
