import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/auths/user_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  RxBool loading = false.obs;
  RxBool fetching = false.obs;

  // INPUT CONTROLLERS
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController postal = TextEditingController();
  final TextEditingController aboutMe = TextEditingController();

  final ProfileController _controller = Get.find<ProfileController>();
  // final ApiService _service = Get.find<ApiService>();
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
    // String? base64Image;
    String? filePath;
    loading.value = true;
    if(file.value != null) {
      filePath = await _authService.uploadImageFile(File(file.value!.path).path);
    }
    bool res = await _authService.updateUser(
      firstName.text,
      lastName.text,
      userName.text,
      phone.text,
      location.text,
      postal.text,
      aboutMe.text,
      profilePic: filePath,
    );
    if(res) {
      await _authService.getUser();
      if(filePath != null) {
        _controller.user.value.profilePic = filePath;
        _controller.user.refresh();
        for (var feed in _controller.feeds) {
          feed?.profilePic = filePath;
        }
        _controller.feeds.refresh();
      }
    }
    loading.value = false;
    Get.offNamed(Get.previousRoute);
  }

  // DELETE ACCOUNT
  deleteAccount() async {
    Get.close;
    fetching.value = true;
    var res = await _authService.deleteUser();
    if(res == true) {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
    fetching.value = false;
  }
}