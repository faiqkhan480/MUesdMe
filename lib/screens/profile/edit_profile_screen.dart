import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/content_edit_card.dart';
import '../../components/custom_header.dart';
import '../../components/email_pass_card.dart';
import '../../components/social_links.dart';
import '../../components/user_info.dart';
import '../../controllers/profile_controller.dart';
import '../../models/auths/user_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;
  const EditProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final ProfileController _controller = Get.find<ProfileController>();
  final AuthService _authService = Get.find<AuthService>();
  final ApiService _apiService = Get.find<ApiService>();

  User? get _user => _authService.currentUser;

  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  // CONTROLLERS
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _aboutMe = TextEditingController();

  bool connectFacebook = false;
  bool connectTwitter = false;
  bool loader = false;

  setValues() {
    _firstName.text = _user?.firstName ?? "";
    _lastName.text = _user?.lastName ?? "";
    _userName.text = _user?.userName ?? "";
    _phone.text = _user?.phone ?? "";
    _aboutMe.text = _user?.aboutMe ?? "";
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
          CustomHeader(
              title: "Edit Profile",
              onSave: handleSubmit,
              loader: loader,
              onClick: handleImage,
              img:
              (_file == null ?
              NetworkImage("${Constants.IMAGE_URL}${_user?.profilePic}") :
              FileImage(File(_file!.path))) as ImageProvider,
          ),

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
    // debugPrint(_file);
    FocusScope.of(context).unfocus();
    setState(() => loader = true);
    String? base64Image;
    if(_file != null) {
      Uint8List imageBytes =  File(_file!.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }
    // debugPrint(base64Image);
    var res = await _authService.updateUser(
        _firstName.text,
        _lastName.text,
        _userName.text,
        _phone.text,
      _aboutMe.text,
      profilePic: base64Image,
    );
    if(res) {
      await _controller.getUserDetails();
    }
    setState(() => loader = false);
    Get.offNamed(Get.previousRoute);
  }

  Future handleImage() async {
    var res = await _picker.pickImage(source: ImageSource.gallery);
    if(res != null) {
      setState(() => _file = res);
    }
  }
}
