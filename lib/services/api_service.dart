import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/api_res.dart';
import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/network.dart';


class ApiService extends GetxService {
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
      debugPrint("json::::::$json");
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

  // SEND FOLLOW REQUEST
  Future<User?> followReq(String followId, int type) async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserID": followId,
        "FollowedBy": User.fromJson(_box.read("user")).userId.toString(),
      };
      final json = await Network.post(url: type == 0 ? Constants.FOLLOW_USER : Constants.UN_FOLLOW_USER, headers: header, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.message != null && res.message!.isNotEmpty) {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
        }
        if(res.code == 200 && res.user != null) {
          User user = User.fromJson(res.user);
          return user;
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }

  // SEND UN FOLLOW REQUEST
  Future<User?> unFollowReq(String followId) async {
    try {
      var header = {
        "Authorization": "Bearer ${_box.read("token")}",
      };
      var payload = {
        "UserID": followId,
        "FollowedBy": User.fromJson(_box.read("user")).userId.toString(),
      };
      final json = await Network.post(url: Constants.UN_FOLLOW_USER, headers: header, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.message != null && res.message!.isNotEmpty) {
          Get.snackbar("Failed!", res.message ?? "",
              backgroundColor: AppColors.pinkColor,
              colorText: Colors.white
          );
        }
        if(res.code == 200 && res.users != null) {
          User user = User.fromJson(res.users);
          return user;
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }
}