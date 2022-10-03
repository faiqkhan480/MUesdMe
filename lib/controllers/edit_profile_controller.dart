import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  RxBool loading = false.obs;

  // INPUT CONTROLLERS
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController postal = TextEditingController();
  final TextEditingController aboutMe = TextEditingController();

  final ProfileController _controller = Get.find<ProfileController>();
  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> file = Rxn<XFile?>();

  RxBool connectFacebook = false.obs;
  RxBool connectTwitter = false.obs;
  RxBool loader = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setValues();
  }


  setValues() {
    firstName.text = _authService.currentUser?.firstName ?? "";
    lastName.text = _authService.currentUser?.lastName ?? "";
    userName.text = _authService.currentUser?.userName ?? "";
    phone.text = _authService.currentUser?.phone ?? "";
    location.text = _authService.currentUser?.location ?? "";
    postal.text = _authService.currentUser?.postalCode ?? "";
    aboutMe.text = _authService.currentUser?.aboutMe ?? "";
  }

  // FETCH USER DETAILS
  Future<void> getUserDetails({int? profileId}) async {
    loading.value = true;
    User? res = await _authService.getUser(uid: profileId);
    _authService.setUser(res);
    loading.value = false;
  }

  Future handleImage() async {
    var res = await _picker.pickImage(source: ImageSource.gallery);
    if(res != null) {
      file.value = res;
    }
  }

  // FORM SUBMISSION
  void handleSubmit() async {
    Get.focusScope?.unfocus();
    String? base64Image;
    loading.value = true;
    if(file.value != null) {
      Uint8List imageBytes =  File(file.value!.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }
    // debugPrint(base64Image);
    var res = await _authService.updateUser(
      firstName.text,
      lastName.text,
      userName.text,
      phone.text,
      location.text,
      postal.text,
      aboutMe.text,
      profilePic: base64Image,
    );
    if(res) {
      await _authService.getUser();
    }
    loading.value = false;
    Get.offNamed(Get.previousRoute);
    // FocusScope.of(context).unfocus();
    // Get.toNamed(AppRoutes.PROFILE_EDIT);
  }
}