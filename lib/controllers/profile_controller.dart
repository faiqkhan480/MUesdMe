import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../models/feed.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class ProfileController extends GetxController {
  RxBool loading = true.obs;
  RxDouble toolbarHeight = 10.0.obs;

  RxBool feedsLoading = true.obs;
  RxBool fetching = false.obs;

  RxInt currIndex = 0.obs;
  RxInt currTab = 0.obs;

  Rx<User> user = User().obs;
  final Rx<ScrollController> scroll = ScrollController().obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  RxList<Feed?> feeds = List<Feed?>.empty(growable: true).obs;
  RxList<CachedVideoPlayerController?> videos = List<CachedVideoPlayerController?>.empty(growable: true).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scroll.value.addListener(() {
      if(scroll.value.position.pixels > 540) {
        toolbarHeight.value = 120;

      } else if(scroll.value.position.pixels < 620) {
        toolbarHeight.value = 35;
      }
    });
    getData();
  }

  // FETCH DATA FROM SERVER
  Future getData() async {
    _getUserDetails();
    _getFeeds();
  }

  // FETCH USER DETAILS
  Future<void> _getUserDetails({int? profileId}) async {
    loading.value = true;
    User? res = await _authService.getUser(uid: profileId);
    user.value = res!;
    loading.value = false;
  }

  // FETCH USER'S FEEDS
  Future<void> _getFeeds() async {
    User? args = Get.arguments;
    // videos.clear();
    List res = await _service.fetchUserPosts(_authService.currentUser!.userId.toString());
    if(res.isNotEmpty) {
      if(feeds.isEmpty) {
        feeds.addAll(res as List<Feed?>);
      }
      else {
        feeds.clear();
        feeds.addAll(res as List<Feed?>);
        // feeds.replaceRange(0, (feeds.length-1), res as List<Feed?>);
      }
      for (var f in feeds) {
        if(f?.feedType == "Video") {
          String url = "${Constants.FEEDS_URL}${f?.feedPath}";
          if(videos.isEmpty || videos.any((v) => v?.dataSource != url)) {
            CachedVideoPlayerController c = CachedVideoPlayerController.network(url);
            await c.initialize();
            videos.add(c);
          }
        }
      }
      update();
    }
    feedsLoading.value = false;
  }

  void handleClick() {
    Get.toNamed(AppRoutes.PROFILE_EDIT);
  }

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
    fetching.value = false;
  }
}