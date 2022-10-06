import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../controllers/call_controller.dart';
import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class CallScreen extends GetView<CallController> {
  const CallScreen({Key? key}) : super(key: key);

  User? get chatUser => controller.user.value;
  AuthService get _authService => Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 80,
                backgroundImage: NetworkImage(
                    chatUser?.profilePic != null && chatUser!.profilePic!.isNotEmpty?
                    Constants.IMAGE_URL + chatUser!.profilePic! :
                    Constants.dummyImage
                ),
              ),
              Column(
                children: [
                  TextWidget(
                      "${chatUser?.firstName?.capitalize} ${chatUser?.lastName?.capitalize}\n",
                    size: Get.textScaleFactor * 35,
                  ),
                  TextWidget(
                    "Calling...",
                    color: AppColors.lightGrey,
                    size: Get.textScaleFactor * 25,
                  ),
                ],
              ),

              // Spacer(),

              RawMaterialButton(
                onPressed: controller.endCall,
                shape: const CircleBorder(),
                elevation: 2.0,
                fillColor: AppColors.orange,
                padding: const EdgeInsets.all(15.0),
                child: const Icon(CupertinoIcons.phone_down,
                  color: Colors.white,
                  size: 34.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
