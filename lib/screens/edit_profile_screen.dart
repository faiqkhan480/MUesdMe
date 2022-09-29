import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/content_edit_card.dart';
import '../components/custom_header.dart';
import '../components/email_pass_card.dart';
import '../components/header.dart';
import '../components/social_links.dart';
import '../components/user_info.dart';
import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/di_setup.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;
  const EditProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? get _user => widget.user;
  final AuthService _authService = getIt<AuthService>();

  // CONTROLLERS
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _aboutMe = TextEditingController();

  bool connectFacebook = false;
  bool connectTwitter = false;
  bool loader = false;
  String _profilePic = "";

  setValues() {
    _firstName.text = _user?.firstName ?? "";
    _lastName.text = _user?.lastName ?? "";
    _userName.text = _user?.userName ?? "";
    _phone.text = _user?.phone ?? "";
    _aboutMe.text = _user?.aboutMe ?? "";
    _profilePic = _user?.profilePic ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:  [
          CustomHeader(title: "Edit Profile",
              onSave: handleSubmit,
              loader: loader,
              imgUrl: _user?.profilePic != null ? "${Constants.IMAGE_URL}${_user?.profilePic}" : null),

          const SizedBox(height: 60,),

          Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    GeneralInfo(
                      firstname: _firstName,
                      lastname: _lastName,
                      phone: _phone,
                      userName: _userName,
                    ),

                    const SizedBox(height: 20,),

                    ContentEditCard(aboutMe: _aboutMe,),

                    const SizedBox(height: 20,),

                    EmailPasswordCard(email: _user?.email),

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

  Future<void> handleSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() => loader = true);
    var res = await _authService.updateUser(
        _firstName.text,
        _lastName.text,
        _userName.text,
        _profilePic,
        _phone.text,
        _aboutMe.text
    );
    setState(() => loader = false);
    // Navigator.pop(context);
  }
}
