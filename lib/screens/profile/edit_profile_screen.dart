import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../components/content_edit_card.dart';
import '../../components/custom_header.dart';
import '../../components/email_pass_card.dart';
import '../../components/social_links.dart';
import '../../components/user_info.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({Key? key}) : super(key: key);

  AuthService get _authService => Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:  [
          CustomHeader(
            title: "Edit Profile",
            onSave: controller.handleSubmit,
            loader: controller.loading(),
            onClick: controller.handleImage,
            img:
            (controller.file.value == null ?
            NetworkImage("${Constants.IMAGE_URL}${_authService.currentUser?.profilePic}") :
            FileImage(File(controller.file.value!.path))) as ImageProvider,
          ),

          const SizedBox(height: 60,),

          Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    GeneralInfo(
                      firstname: controller.firstName,
                      lastname: controller.lastName,
                      phone: controller.phone,
                      userName: controller.userName,
                      location: controller.location,
                      postal: controller.postal,
                    ),

                    const SizedBox(height: 20,),

                    ContentEditCard(aboutMe: controller.aboutMe,),

                    const SizedBox(height: 20,),

                    EmailPasswordCard(email: _authService.currentUser?.email),

                    const SizedBox(height: 20,),

                    SocialLinks(
                      val1: controller.connectTwitter.value,
                      val2: controller.connectFacebook.value,
                      action1: (val) => null,
                      action2: (val) => null,
                    ),

                    const SizedBox(height: 20,),

                    TextButton(
                      onPressed: controller.deleteAccount,
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                          textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.iconsDelete),
                          const SizedBox(width: 5,),
                          const Text("Delete Account"),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
        ],
      )),
    );
  }
}
