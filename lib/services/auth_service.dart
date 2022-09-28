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
  // User? _currentUser;
  //
  // set setCurrentUser(User value) {
  //   _currentUser = value;
  // }
  //
  // User? get currentUser => _currentUser;
  final GetStorage _box = GetStorage();


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
          User currentUser = User.fromJson(res.users);
          debugPrint("::::::::: ${currentUser.token}");
          _box.write("user", res.users);
          _box.write("token", currentUser.token);
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
          User currentUser = User.fromJson(res.users);
          _box.write("user", res.users);
          _box.write("token", currentUser.token);
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
}