import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/api_res.dart';
import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/network.dart';


class ApiService {
  final GetStorage _box = GetStorage();

  // GET USER FEEDS/POSTS
  Future<List<Feed?>> fetchPosts() async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserID": User.fromJson(_box.read("user")).userId.toString(),
      };
      final json = await Network.post(url: Constants.FEEDS, headers: header, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.message != null && res.message!.isNotEmpty) {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
        }
        if(res.code == 200 && res.feeds != null) {
          List<Feed> feeds = feedFromJson(jsonEncode(res.feeds));
          return feeds;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }

  // GET USERS FROM SEARCH
  Future<List<User?>> fetchUsers(String search) async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserID": User.fromJson(_box.read("user")).userId.toString(),
        "Name": search,
      };
      final json = await Network.post(url: Constants.SERACH_USER, headers: header, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.message != null && res.message!.isNotEmpty) {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
        }
        if(res.code == 200 && res.users != null) {
          List<User> _users = userFromJson(jsonEncode(res.users));
          return _users;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }
}