import 'package:cached_video_player/cached_video_player.dart';
import 'package:get/get.dart';

import '../models/feed.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class FeedController extends GetxController {
  RxList<Feed?> feeds = List<Feed?>.empty(growable: true).obs;
  RxBool loading = true.obs;

  final ApiService _service = Get.find<ApiService>();

  // RxList<CachedVideoPlayerController?> _controller = List<CachedVideoPlayerController?>.empty(growable: true).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFeeds();
  }

  // FETCH FEEDS
  Future<void> getFeeds() async {
    List res = await _service.fetchPosts();
    if(res.isNotEmpty) {
      feeds.addAll(res as List<Feed?>);
      // feeds.forEach((f) {
      //   if(f?.feedType == "Video") {
      //
      //   }
      // });
    }
    loading.value = false;
  }

  void handleNavigation() {
    Get.toNamed(AppRoutes.SEARCH);
    // Navigator.push(context, CupertinoPageRoute(builder: (context) => const SearchUserScreen()));
  }
}