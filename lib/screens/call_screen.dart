import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/call_controller.dart';
import '../models/args.dart';
import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/style_config.dart';
import '../widgets/loader.dart';
import '../widgets/text_widget.dart';

class CallScreen extends GetView<CallController> {
  const CallScreen({Key? key}) : super(key: key);

  User? get chatUser => controller.user.value;
  AuthService get _authService => Get.find<AuthService>();
  CallType get _type => controller.type.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: AppColors.secondaryColor.withOpacity(0.4),
        // decoration: StyleConfig.gradientBackground,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 20, right: 20, left: 20),
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
              const Spacer(),
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

              // const Spacer(),

              // RawMaterialButton(
              //   onPressed: controller.endCall,
              //   shape: const CircleBorder(),
              //   elevation: 2.0,
              //   fillColor: AppColors.orange,
              //   padding: const EdgeInsets.all(15.0),
              //   child: const Icon(CupertinoIcons.phone_down,
              //     color: Colors.white,
              //     size: 34.0,
              //   ),
              // ),

              // SizedBox.shrink(),

              const CallLoader(),

              TextButton(
                onPressed: controller.endCall,
                style: TextButton.styleFrom(
                    backgroundColor: _type == CallType.outgoing ? AppColors.primaryColor : AppColors.successColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                ),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.phone_down, color: Colors.white,),
                    // SvgPicture.asset(Assets.iconsDelete),
                    SizedBox(width: 5,),
                    TextWidget("End Call", weight: FontWeight.w500, size: 18, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
