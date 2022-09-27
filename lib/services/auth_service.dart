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

  // Future registerUser(RegistrationRequest request) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(UrlConstants.REGISTER),
  //       headers: UrlConstants.HEADERS,
  //       body: json.encode(request.toJson()),
  //     );
  //
  //     final body = json.decode(response.body);
  //
  //     debugPrint("Register Response: - ${response.statusCode}: $body");
  //
  //     if (body != null) {
  //       // var base = AuthBaseResponse.fromJson(body);
  //       var base = BooleanResponse.fromJson(body);
  //
  //       if (base.status == ApiResponseCodes.SUCCESSFUL) {
  //         // if (base.status == ApiResponseCodes.SUCCESSFUL && base.result != null) {
  //         // _currentUser = base.result;
  //         return base;
  //       }
  //       else if(base.status == ApiResponseCodes.SUCCESSFUL) {
  //         throw APIException(base.message, base.status);
  //       }
  //       else {
  //         throw APIException(base.message, base.status);
  //       }
  //     }
  //   } catch (e) {
  //     if (e is APIException) {
  //       rethrow;
  //     } else {
  //       throw Exception(getErrorMessage(e));
  //     }
  //   }
  // }
}