import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/agora_controller.dart';
import '../utils/app_colors.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar(this.url, this.uid,{Key? key, this.badgeContent, this.padding, this.radius}) : super(key: key);

  final EdgeInsets? padding;
  final Widget? badgeContent;
  final String url;
  final String uid;
  final double? radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  bool isOnline = false;

  AgoraController get _agora => Get.find<AgoraController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  checkStatus() async {
    bool res =  await _agora.isUserOnline(widget.uid);
    setState(() {
      isOnline = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeColor: isOnline ? AppColors.successColor : AppColors.lightGrey,
      position: BadgePosition.topEnd(top: -1, end: 4),
      elevation: 0,
      padding: widget.padding ?? const EdgeInsets.all(5.0),
      badgeContent: widget.badgeContent,
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
      child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: widget.radius ?? 25,
          backgroundImage: NetworkImage(widget.url,)
      ),
    );
  }
}
