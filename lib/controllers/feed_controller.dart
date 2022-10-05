import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../models/feed.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class FeedController extends GetxController {
  RxList<Feed?> feeds = List<Feed?>.empty(growable: true).obs;
  RxBool loading = true.obs;

  final ApiService _service = Get.find<ApiService>();

  RxList<CachedVideoPlayerController?> videos = List<CachedVideoPlayerController?>.empty(growable: true).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFeeds();
  }

  // FETCH FEEDS
  Future<void> getFeeds() async {
    // videos.clear();
    List res = await _service.fetchPosts();
    if(res.isNotEmpty) {
      if(feeds.isEmpty) {
        feeds.addAll(res as List<Feed?>);
      }
      else {
        feeds.replaceRange(0, (feeds.length-1), res as List<Feed?>);
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
}