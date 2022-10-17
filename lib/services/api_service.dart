import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/api_res.dart';
import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/comment.dart';
import '../models/feed.dart';
import '../models/message.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/network.dart';


class ApiService extends GetxService {
  final GetStorage _box = GetStorage();

  // REQUEST AUTHORIZATION HEADER
  Map<String, String> get _header => {"Authorization": "Bearer ${_box.read("token")}",};
  String get _userId => User.fromJson(_box.read("user")).userId.toString();

  // GET FEEDS/POSTS
  Future<List<Feed?>> fetchPosts() async {
    try {
      var payload = {
        "UserID": _userId,
      };
      final json = await Network.post(url: Constants.FEEDS, headers: _header, payload: payload);
      // debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
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

  // GET FEEDS/POSTS AGAINST USER
  Future<List<Feed?>> fetchUserPosts(String uid) async {
    try {
      var payload = {
        "UserID": uid,
      };
      final json = await Network.post(url: Constants.USERS_FEEDS, headers: _header, payload: payload);
      // debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
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
      var payload = {
        "UserID": _userId,
        "Name": search,
      };
      final json = await Network.post(url: Constants.SERACH_USER, headers: _header, payload: payload);
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
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
      var payload = {
        "UserID": followId,
        "FollowedBy": _userId,
      };
      final json = await Network.post(url: type == 0 ? Constants.FOLLOW_USER : Constants.UN_FOLLOW_USER, headers: _header, payload: payload);
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
      var payload = {
        "UserID": followId,
        "FollowedBy": _userId,
      };
      final json = await Network.post(url: Constants.UN_FOLLOW_USER, headers: _header, payload: payload);
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

  // SEND LIKE REQUEST AGAINST FEED
  Future<bool> sendLike(String feedId) async {
    try {
      var payload = {
        "UserID": _userId,
        "FeedID": feedId,
      };
      final json = await Network.post(url: Constants.LIKE_POST, headers: _header, payload: payload);
      // debugPrint("CALLED:::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200) {
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      Get.snackbar("Exception!", e.toString(),
          backgroundColor: AppColors.pinkColor,
          colorText: Colors.white
      );
      return false;
    }
  }

  //GET FEED COMMENTS
  Future<List<Comment?>> fetchComments(String feedId) async {
    try {
      var payload = {
        "FeedID": feedId,
      };
      final json = await Network.post(url: Constants.GET_COMMENTS, headers: _header, payload: payload);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
        if(res.code == 200 && res.feedComments != null) {
          List<Comment> comments = commentFromJson(jsonEncode(res.feedComments));
          return comments;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }

  // POST COMMENT
  Future<List<Comment?>> postComments(String feedId, String comment) async {
    try {
      var payload = {
        "UserID": _userId,
        "FeedID": feedId,
        "Comment": comment,
      };
      final json = await Network.post(url: Constants.ADD_COMMENT, headers: _header, payload: payload);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
        if(res.code == 200 && res.feedComments != null) {
          List<Comment> comments = commentFromJson(jsonEncode(res.feedComments));
          return comments;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }

  // UPLOAD FEED FILE
  Future<String?> uploadFeedFile(String filePath) async {
    try {
      final json = await Network.multipart(url: Constants.UPLOAD_FILE, headers: _header, filePath: filePath);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.feed != null) {
            Feed? feed = Feed.fromJson(res.feed);
          return feed.feedPath;
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

  // UPLOAD FEED
  Future uploadFeed(String feedPath, String type, String privacy) async {
    try {
      var payload = {
        "FeedType": type,
        "WHoCanSee": privacy,
        "UserID": _userId,
        "FeedPath": feedPath,
      };
      final json = await Network.post(url: Constants.UPLOAD_FEED, headers: _header, payload: payload);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
        if(res.code == 200 && res.message != null) {
        //   List<Comment> comments = commentFromJson(jsonEncode(res.feedComments));
        //   return comments;
        //   Get.snackbar("Success!", res.message ?? "",
        //       backgroundColor: AppColors.successColor,
        //       colorText: Colors.white
        //   );
           return true;
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }

  // SHARE FEED
  Future shareFeed(String feedID, String privacy) async {
    try {
      var payload = {
        "FeedID": feedID,
        "WHoCanSee": privacy,
        "UserID": _userId,
      };
      final json = await Network.post(url: Constants.SHARE_FEED, headers: _header, payload: payload);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        // if(res.message != null && res.message!.isNotEmpty) {
        //   Get.snackbar("Failed!", res.message ?? "",
        //       backgroundColor: AppColors.pinkColor,
        //       colorText: Colors.white
        //   );
        // }
        if(res.code == 200 && res.message != null) {
          //   List<Comment> comments = commentFromJson(jsonEncode(res.feedComments));
          //   return comments;
          Get.back();
          Get.snackbar("Success!", res.message ?? "",
              backgroundColor: AppColors.successColor,
              colorText: Colors.white
          );
          return true;
        }
      }
      return null;
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return null;
    }
  }

  //GET ALL CHATS
  Future<List<Chat?>> getAllChats() async {
    try {
      var payload = {
        "UserID": _userId,
      };
      final json = await Network.post(url: Constants.GET_CHAT, headers: _header, payload: payload);
      // debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.messages != null) {
          List<Chat> chats = chatFromJson(jsonEncode(res.messages));
          return chats;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }

  //GET ALL MESSAGES
  Future<List<Message?>> getAllMessages(String chatId) async {
    try {
      var payload = {
        "ChatID": chatId,
      };
      final json = await Network.post(url: Constants.GET_MESSAGES, headers: _header, payload: payload);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.messages != null) {
          List<Message> message = messageFromJson(jsonEncode(res.messages));
          return message;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }

  // SAVE MESSAGE TO SERVER
  Future sendMessage(String chatId, String message, String chatWithUser, int isActive, {String? type}) async {
    try {
      var payload = {
        "ChatID": chatId,
        "UserID": _userId,
        "Message": message,
        "ChatWithUser": chatWithUser,
        "IsActive": 0,
        "Type": type
      };
      final json = await Network.post(url: Constants.SEND_MESSAGE, headers: _header, payload: payload);
      // debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.message != null) {
          return true;
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

  // GET ACTIVE USERS
  Future<List<User?>> fetchActiveUsers() async {
    try {
      var payload = {
        "UserID": _userId,
      };
      final json = await Network.post(url: Constants.ACTIVE_USERS, headers: _header, payload: payload);
      debugPrint("RES:::::::::::: $json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.users != null) {
          List<User> users = userFromJson(jsonEncode(res.users));
          return users;
        }
      }
      return [];
    } catch (e) {
      debugPrint("ERROR >>>>>>>>>> $e");
      return [];
    }
  }

  // GO LIVE
  Future goLive(bool status) async {
    try {
      var payload = {
        "UserID": _userId,
        "IsLive": status ? "1" : "0",
      };
      final json = await Network.post(url: Constants.GO_LIVE, headers: _header, payload: payload);
      debugPrint("json::::::$json");
      if(json != null) {
        ApiRes res = ApiRes.fromJson(jsonDecode(json));
        if(res.code == 200 && res.message != null) {
          return true;
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
}