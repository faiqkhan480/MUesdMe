import 'package:cached_video_player/cached_video_player.dart';
import 'package:get/get.dart';

import '../models/feed.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
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
    List res = await _service.fetchPosts();
    if(res.isNotEmpty) {
      feeds.addAll(res as List<Feed?>);
      for (var f in feeds) {
        if(f?.feedType == "Video") {
          CachedVideoPlayerController _C = CachedVideoPlayerController.network("${Constants.FEEDS_URL}${f?.feedPath}");
          await _C.initialize();
          videos.add(_C);
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
}