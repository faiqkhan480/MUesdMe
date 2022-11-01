import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/api_res.dart';
import '../models/auths/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/network.dart';

class AuthService extends GetxService {
  final GetStorage _box = GetStorage();
  User? _currentUser;
  String? rtc;
  String? rtm;

  User? get currentUser => _currentUser;

  late final bool isAuthenticated;

  // REQUEST AUTHORIZATION HEADER
  Map<String, String> get _header => {"Authorization": "Bearer ${_box.read("token")}",};

  Future<AuthService> init() async {
    if(_box.read("token") != null && _box.read("user") != null) {
      isAuthenticated = _box.read("token") != null;
      _currentUser = User.fromJson(_box.read("user"));
      getTokens();
    }
    return this;
  }

  Future getTokens() async {
    if(_box.read("rtc") != null) {
      rtc = _box.read("rtc");
    }
    else {
      var res = await getRTC();
      rtc = res;
    }
    if(_box.read("rtm") != null) {
      rtm = _box.read("rtm");
    }
    else {
      var res = await getRTM();
      rtm = res;
      // getRTM().then((value) => rtm = value);
    }
  }

  updateAuth() {
    isAuthenticated = false;
  }

  setUser(User? u) {
    _currentUser = u;
  }

  // USER LOGIN
  Future<bool> loginUser(String email, String pass, int isSocial) async {
    try {
      var payload = {
        "Email": email,
        "Password": pass,
        "isSocial": isSocial,
        "FCMToken": _box.read("fcm")
      };
      final json = await Network.post(url: Constants.LOGIN, payload: payload);
      // debugPrint("LOGIN RES::::::::: $json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.user != null) {
          _currentUser = User.fromJson(res.user);
          _box.write("user", res.user);
          _box.write("token", _currentUser?.token);
          await getTokens();
          return true;
        }
        else {
          Get.snackbar("Login Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return false;
    }
  }

  // GET RTM TOKEN
  Future<String?> getRTM() async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserId": currentUser?.userId,
      };
      final json = await Network.post(url: Constants.GET_RTM, payload: payload, headers: header);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.token != null) {
          _box.write("rtm", res.token);
          return res.token;
        }
        else {
          Get.snackbar("GET RTM Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return null;
        }
      }
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      Get.snackbar("Error!", "$e",
          backgroundColor: AppColors.pinkColor,
          colorText: Colors.white
      );
      return null;
    }
  }

  // GET RTC TOKEN
  Future<String?> getRTC() async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserId": currentUser?.userId,
      };
      final json = await Network.post(url: Constants.GET_RTC, payload: payload, headers: header);
      debugPrint("RTC JSON :::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.token != null) {
          _box.write("rtc", res.token);
          return res.token;
        }
        else {
          Get.snackbar("GET RTC Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return null;
        }
      }
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      Get.snackbar("Error!", "$e",
          backgroundColor: AppColors.pinkColor,
          colorText: Colors.white
      );
      return null;
    }
  }

  // USER SIGNUP
  Future registerUser(
      String firstName,
      String lastName,
      String userName,
      String email,
      String? gender,
      String country,
      String? dob,
      String password,
      int isSocial,
      ) async {
    try {
      var payload = {
        "Email": email,
        "Password": password,
        "FirstName": firstName,
        "LastName": lastName,
        "UserName": userName,
        "Country": country,
        "DOB": dob,
        "Gender": gender,
        "isSocial": isSocial,
        "FCMToken": _box.read("fcm")
      };
      final json = await Network.post(url: Constants.REGISTER, payload: payload);
      debugPrint("JSON:::::::::: ${json}");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.user != null) {
          _currentUser = User.fromJson(res.user);
          _box.write("user", res.user);
          _box.write("token", _currentUser?.token);
          await getTokens();
          return true;
        }
        else {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return false;
    }
  }

  // GET USER DETAILS
  Future<User?> getUser({int? uid, int? followedBy}) async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserId":  (uid ?? User.fromJson(_box.read("user")).userId).toString(),
        "FollowedBy":  followedBy?.toString(),
      };
      final json = await Network.post(url: Constants.USER_DETAILS, payload: payload, headers: header);
      debugPrint("JSON  $json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.user != null) {
          if(uid != null) {
            return User.fromJson(res.user);
          }
          _currentUser = User.fromJson(res.user);
          _box.write("user", res.user);
          return _currentUser;
        }
        else {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return null;
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }

  // UPLOAD PROFILE IMAGE FILE
  Future<String?> uploadImageFile(String filePath) async {
    try {
      final json = await Network.multipart(url: Constants.UPLOAD_IMAGE, headers: _header, filePath: filePath);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.user != null) {
          User? u = User.fromJson(res.user);
          return u.profilePic;
        }
        else {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }

  // UPDATE USER DETAILS
  Future<bool> updateUser(
      String firstName,
      String lastName,
      String userName,
      String phone,
      String location,
      String postalCode,
      String aboutMe,
      {String? profilePic,}) async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserID": _currentUser?.userId.toString(),
        "FirstName": firstName,
        "LastName": lastName,
        "UserName": userName,
        "Phone": phone,
        "Location": location,
        "PostalCode": postalCode,
        "AboutMe": aboutMe,
      };
      if(profilePic != null && profilePic.isNotEmpty) {
        payload.addAll({"ProfilePic": profilePic});
      }
      final json = await Network.post(url: Constants.UPDATE_USER, payload: payload, headers: header);

      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        Get.snackbar(res.code != 200 ? "Failed!" : "Success!", res.message ?? "",
            backgroundColor: res.code != 200 ? AppColors.pinkColor : AppColors.green,
            colorText: Colors.white
        );
        return res.code == 200;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> ${e.runtimeType}");
      Get.snackbar("Failed!", "Error in request",
          backgroundColor: AppColors.pinkColor,
          colorText: Colors.white
      );
      return false;
    }
  }

  Future clearUser() async {
    _box.remove("token");
    _box.remove("user");
    _box.remove("rtm");
    _box.remove("rtc");
    // await _box.erase();
    // _box.write("token", null);
    // _box.write("user", null);
    _currentUser = null;
  }

  Future deleteUser() async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserId":  User.fromJson(_box.read("user")).userId.toString(),
      };
      final json = await Network.post(url: Constants.DELETE_USER, payload: payload, headers: header);
      debugPrint("JSON  $json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200) {
          Get.snackbar("Success!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          await clearUser();
          return true;
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }

  // FORGOT PASSWORD
  Future<bool> forgotPass(String email) async {
    try {
      var payload = {
        "Email": email,
      };
      final json = await Network.post(url: Constants.FORGOT_PASSWORD, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200) {
          Get.snackbar("Success!", res.message ?? "",
              backgroundColor: AppColors.successColor,
              colorText: Colors.white
          );
          return true;
        }
        else {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return false;
    }
  }

  // VERIFY PASSWORD
  Future<bool> verifyPassCode(String email, String code) async {
    try {
      var payload = {
        "Email": email,
        "Code": code,
      };
      final json = await Network.post(url: Constants.VERIFY_PASSWORD, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200) {
          Get.snackbar("Success!", res.message ?? "",
              backgroundColor: AppColors.successColor,
              colorText: Colors.white
          );
          return true;
        }
        else {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return false;
    }
  }

  // UPDATE PASSWORD
  Future<bool> updatePassword(String email, String password) async {
    try {
      var payload = {
        "Email": email,
        "Password": password,
      };
      final json = await Network.post(url: Constants.UPDATE_PASSWORD, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200) {
          Get.back();
          Get.snackbar("Success!", res.message ?? "",
              backgroundColor: AppColors.successColor,
              colorText: Colors.white
          );
        }
        else {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return false;
    }
  }
}