import 'package:cached_video_player/cached_video_player.dart';
import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../models/chat.dart';
import '../models/feed.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'chat_controller.dart';

class UserProfileController extends GetxController {
  RxBool loading = true.obs;
  RxBool feedsLoading = true.obs;

  RxBool fetching = false.obs;

  RxInt currIndex = 0.obs;
  RxInt currTab = 0.obs;

  Rx<User> user = User().obs;

  RxList<Feed?> feeds = List<Feed?>.empty(growable: true).obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  RxList<CachedVideoPlayerController?> videos = List<CachedVideoPlayerController?>.empty(growable: true).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  // FETCH DATA FROM SERVER
  Future getData() async {
    _getUserDetails();
    _getFeeds();
  }

  // FETCH USER'S DATA
  Future<void> _getUserDetails({int? profileId}) async {
    User? args = Get.arguments;
    loading.value = true;
    User? res = await _authService.getUser(uid: args?.userId, followedBy: _authService.currentUser?.userId);
    user.value = res!;
    loading.value = false;
  }

  // FETCH USER'S FEEDS
  Future<void> _getFeeds() async {
    User? args = Get.arguments;
    // videos.clear();
    List res = await _service.fetchUserPosts(args!.userId!.toString());
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
    feedsLoading.value = false;
  }

  Future<void> sendFollowReq() async {
    loading.value = true;
    // debugPrint("UID ${profile.value.userId} FOLLOW${profile.value.follow}");
    User? res = await _service.followReq((user.value.userId ?? "").toString(), user.value.follow ?? 0);
    user.value.follow = user.value.follow == 0 ? 1 : 0;
    user.value.followers = res?.followers;
    loading.value = false;
  }

  void handleClick() {
    Get.to(AppRoutes.PROFILE_EDIT, transition: Transition.leftToRight);
  }

  navigateToChat() {
    final ChatController _chat = Get.find<ChatController>();
    Chat? c = _chat.chats.firstWhereOrNull((c) => c?.userId == user.value.userId);
    Get.toNamed(AppRoutes.MESSAGES, arguments: c ?? Chat(
      userId: user.value.userId,
      chatId: 0,
      fullName: "${user.value.firstName} ${user.value.lastName}",
      message: "",
      messageDate: DateTime.now(),
      profilePic: user.value.profilePic,
    ));
  }

  navigateToCall() {
    Get.toNamed(AppRoutes.CALL, arguments: user.value);
  }

  // LIKE ON FEED
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

  // UPDATE COMMENT COUNT
  updateCommentCount(int feedId, int count) {
    feeds.firstWhere((feed) => feed?.feedId == feedId)?.postComments = count;
    feeds.refresh();
  }
}