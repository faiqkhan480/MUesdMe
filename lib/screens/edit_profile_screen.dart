import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/content_edit_card.dart';
import '../components/custom_header.dart';
import '../components/email_pass_card.dart';
import '../components/header.dart';
import '../components/social_links.dart';
import '../components/user_info.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool connectFacebook = false;
  bool connectTwitter = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:  [
          const CustomHeader(title: "Edit Profile"),

          const SizedBox(height: 60,),

          Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    const GeneralInfo(),

                    const SizedBox(height: 20,),

                    const ContentEditCard(),

                    const SizedBox(height: 20,),

                    const EmailPasswordCard(),

                    const SizedBox(height: 20,),

                    SocialLinks(
                      val1: connectTwitter,
                      val2: connectFacebook,
                      action1: (val) => setState(() => connectTwitter = val),
                      action2: (val) => setState(() => connectFacebook = val),
                    ),

                    const SizedBox(height: 20,),

                    TextButton(
                      onPressed: () => null,
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
      ),
    );
  }
}
