import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musedme/models/api_res.dart';
import 'package:musedme/utils/constants.dart';

import '../models/auths/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/network.dart';

// import 'package:http/http.dart' as http;

class AuthService {
  User? _currentUser;

  set setCurrentUser(User value) {
    _currentUser = value;
  }

  User? get currentUser => _currentUser;
  final GetStorage _box = GetStorage();


  // USER LOGIN
  Future<bool> loginUser(String email, String pass) async {
    try {
      var payload = {
        "Email": email,
        "Password": pass,
        "FCMToken": ""
      };
      final json = await Network.post(url: Constants.LOGIN, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.users != null) {
          _currentUser = User.fromJson(res.users);
          // debugPrint("::::::::: ${_currentUser?.userName}");
          _box.write("user", res.users);
          _box.write("token", _currentUser?.token);
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

  // USER SIGNUP
  Future registerUser(
    String firstName,
    String lastName,
    String userName,
    String email,
    String gender,
    String country,
    String dob,
    String password,
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
      };
      final json = await Network.post(url: Constants.REGISTER, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.users != null) {
          _currentUser = User.fromJson(res.users);
          _box.write("user", res.users);
          _box.write("token", _currentUser?.token);
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
  Future<User?> getUser() async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserId": User.fromJson(_box.read("user")).userId.toString(),
      };
      final json = await Network.post(url: Constants.USER_DETAILS, payload: payload, headers: header);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.users != null) {
          _currentUser = User.fromJson(res.users);
          _box.write("user", res.users);
          // _box.write("token", _currentUser?.token);
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

  // UPDATE USER DETAILS
  Future updateUser(
      String firstName,
      String lastName,
      String userName,
      String profilePic,
      String phone,
      String aboutMe
      ) async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserID": _currentUser?.userId.toString(),
        "FirstName": firstName,
        "LastName": lastName,
        "UserName": userName,
        "ProfilePic": profilePic,
        "Phone": phone,
        "AboutMe": aboutMe,
      };
      final json = await Network.post(url: Constants.UPDATE_USER, payload: payload, headers: header);
      debugPrint("RESPONSE>>>>>>>>>>>>>>>>>>> $json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        Get.snackbar(res.code != 200 ? "Failed!" : "Success!", res.message ?? "",
            backgroundColor: res.code != 200 ? AppColors.pinkColor : AppColors.green,
            colorText: Colors.white
        );
        if(res.code == 200) {
          await getUser();
          // _currentUser = User.fromJson(res.users);
          // _box.write("user", res.users);
        }
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
}