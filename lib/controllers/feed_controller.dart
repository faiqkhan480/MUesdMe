// import 'package:cached_video_player/cached_video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'agora_controller.dart';
import 'root_controller.dart';

class FeedController extends GetxController {
  RxList<Feed?> feeds = List<Feed?>.empty(growable: true).obs;
  RxList<User?> users = List<User?>.empty(growable: true).obs;
  RxBool loading = true.obs;
  RxBool fetching = false.obs;
  RxBool gettingUsers = true.obs;

  RxInt currIndex = 0.obs;
  RxInt currTab = 0.obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  final RootController _bottomNavigation = Get.find<RootController>();

  BetterPlayerListVideoPlayerController betterCtrl= BetterPlayerListVideoPlayerController();
  BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(autoPlay: true);
  // RxList<CachedVideoPlayerController?> videos = List<CachedVideoPlayerController?>.empty(growable: true).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
    betterCtrl = BetterPlayerListVideoPlayerController();
    // betterPlayerConfiguration = const BetterPlayerConfiguration(autoPlay: true);
  }

  Future<void> getData() async {
    getFeeds();
    getActiveUsers();
  }

  // FETCH FEEDS
  Future<void> getFeeds({bool? force}) async {
    // videos.clear();
    if(force == true) {
      loading.value = force!;
    }
    List res = await _service.fetchPosts();
    if(res.isNotEmpty) {
      if(feeds.isEmpty) {
        feeds.addAll(res as List<Feed?>);
      }
      else {
        feeds.clear();
        feeds.addAll(res as List<Feed?>);
        // feeds.replaceRange(0, (feeds.length-1), res as List<Feed?>);
      }
      // for (var f in feeds) {
      //   if(f?.feedType == "Video") {
      //     String url = "${Constants.FEEDS_URL}${f?.feedPath}";
      //     if(videos.isEmpty || videos.any((v) => v?.dataSource != url)) {
      //       CachedVideoPlayerController c = CachedVideoPlayerController.network(url);
      //       await c.initialize();
      //       videos.add(c);
      //     }
      //   }
      // }
      // update();
    }
    loading.value = false;
  }

  void handleNavigation() {
    Get.toNamed(AppRoutes.SEARCH);
    // Navigator.push(context, CupertinoPageRoute(builder: (context) => const SearchUserScreen()));
  }

  // DOWNLOAD MEDIA
  void handleDownload(String url, bool isVideo) {
    String path = "${Constants.FEEDS_URL}$url";
    if(isVideo) {
      _saveNetworkVideo(path);
    }
    else {
      _saveNetworkImage(path);
    }
  }

  // SAVE/DOWNLOAD IMAGE
  void _saveNetworkVideo(String path) async {
    GallerySaver.saveVideo(path).then((bool? success) {
      if(success!) {
        Get.snackbar("Success", "Image is saved to your device!", backgroundColor: AppColors.successColor, colorText: Colors.white);
      }
    });
  }

  // SAVE/DOWNLOAD VIDEO
  void _saveNetworkImage(String path) async {
    GallerySaver.saveImage(path).then((bool? success) {
      if(success!) {
        Get.snackbar("Success", "Video saved is to your device!", backgroundColor: AppColors.successColor, colorText: Colors.white);
      }
    });
  }

  // NAVIGATE TO USER'S PROFILE
  void gotoProfile(User u) {
    if(u.userId != _authService.currentUser?.userId) {
      Get.toNamed(AppRoutes.USER_PROFILE, arguments: u);
    }
    else {
      _bottomNavigation.handleTab(4);
    }
  }

  // LIKE OR UNLIKE THE FEED
  handleLike(int index, int feedId, {int? currentTab}) async {
    currIndex.value = index;
    currTab.value = currentTab ?? 0;
    fetching.value = true;
    String? status = feeds.firstWhere((feed) => feed?.feedId == feedId)?.postLiked;
    int count = feeds.firstWhere((feed) => feed?.feedId == feedId)?.postLikes ?? 0;
    bool res = await _service.sendLike(feedId.toString());
    if(res) {
      feeds.firstWhere((feed) => feed?.feedId == feedId)?.postLiked = (status == "Like") ? "Liked" : "Like";
      feeds.firstWhere((feed) => feed?.feedId == feedId)?.postLikes = (status == "Like") ? count+1 : count-1;
    }
    feeds.refresh();
    fetching.value = false;
  }

  // UPDATE COMMENT COUNT
  updateCommentCount(int feedId, int count) {
    feeds.firstWhere((feed) => feed?.feedId == feedId)?.postComments = count;
    feeds.refresh();
  }

  // FETCH USERS
  Future<void> getActiveUsers() async {
    List<User?> res = await _service.fetchActiveUsers();
    users.clear();
    users.addAll(res);
    gettingUsers.value = false;
  }


  // GO TO LIVE SCREEN TO WATCH LIVE BROADCAST
  Future watchLive(User u) async {
    await [Permission.camera, Permission.microphone].request();
    Get.toNamed(AppRoutes.LIVE, arguments: {"isBroadcaster": false, 'broadcaster': u});
  }
}