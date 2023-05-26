
import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';

import '../components/custom_header.dart';
import '../controllers/feed_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';

class UploadScreen extends StatefulWidget {
  final PhotoEditorResult? post;
  final VideoEditorResult? video;
  const UploadScreen({Key? key, this.post, this.video}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool loading = false;
  String? get img => widget.post?.image.substring(7).replaceAll("%20", " ");
  String? get video => widget.video?.video.substring(7);
  String value = "Public";

  late BetterPlayerController _betterPlayerController;
  late Subscription _subscription;

  final ApiService _service = Get.find<ApiService>();
  final FeedController _feeds = Get.find<FeedController>();
  final ProfileController _profile = Get.find<ProfileController>();

  getFile() async {
    final root = await getApplicationDocumentsDirectory();
    final path = "$root/${widget.post?.image}";
    File? f = await File(path).create(recursive: true);
  }

  // initializeVideo() async {
  //   _controller = CachedVideoPlayerController.network(video!);
  //   _controller.initialize().then((_) {
  //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //     setState(() {});
  //   });
  // }

  @override
  void initState() {
    requestLocationPermission();
    // TODO: implement initState
    super.initState();
    if(video != null) {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          video!);
      _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            fit: BoxFit.cover,
            autoPlay: true,
            aspectRatio: 1,
          ),
          betterPlayerDataSource: betterPlayerDataSource);
      // _subscription =
      //     VideoCompress.compressProgress$.subscribe((progress) {
      //       debugPrint('progress: $progress');
      //     });
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.storage.request();
    Permission.photos.request();

    if (status == PermissionStatus.granted) {
      debugPrint('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      debugPrint('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      debugPrint('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  @override
  void dispose() {
    // _subscription.unsubscribe;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER
          const CustomHeader(
              title: "Upload Feed",
              buttonColor: AppColors.primaryColor,
              showBottom: false,
              showSave: false
          ),
          Flexible(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(img != null)
                  ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.file(
                    File(img!),
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                )
                else
                  videoWidget(),

                DropdownButtonHideUnderline(child: DropdownButton(
                      items: ["Public", "Friends", "Only me"].map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )).toList(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      onChanged: (d) async {
                        setState(() {
                          value = d!;
                        });
                      },
                      value: value,
                    )),

                const Spacer(),
                if(loading)
                  const SizedBox(
                      height: 55,
                      child: Center(child: Loader(),))
                else
                TextButton(
                  onPressed: uploadFeed,
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Feather.upload, color: Colors.white),
                      // SvgPicture.asset(Assets.iconsDelete),
                      SizedBox(width: 5,),
                      Text("Upload"),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget videoWidget() {
    // return _controller.value.isInitialized ?
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        // width: MediaQuery.of(context).size.width,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
                aspectRatio: 1,
                child: BetterPlayer(
                  controller: _betterPlayerController,
              )
                // child: CachedVideoPlayer(_controller)
            ),
          ),
        ));
    // :
    // const Loader();
  }

  uploadFeed() async {
    if(img != null) {
      _uploadImage();
    }
    else {
      _uploadVideo();
    }
  }

  _uploadImage() async {
    setState(() {
      loading = true;
    });
    // String feedPath, String type, String privacy
    String? filePath = await _service.uploadFeedFile(File(img!).path);
    if(filePath != null) {
      var res = await _service.uploadFeed(filePath, "Image", value);
      if(res == true) {
        await _feeds.getFeeds();
        await _profile.getData();
        Get.close(2);
      }
    }
    setState(() {
      loading = false;
    });
  }

  _uploadVideo() async {
    setState(() {
      loading = true;
    });
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      video!,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    // String feedPath, String type, String privacy
    String? filePath = await _service.uploadFeedFile(mediaInfo!.path!);
    if(filePath != null) {
      var res = await _service.uploadFeed(filePath, "Video", value);
      if(res == true) {
        await _feeds.getFeeds(force: true);
        await _profile.getData();
        await VideoCompress.deleteAllCache();
        Get.snackbar("Success!", "feed uploaded!",
            backgroundColor: AppColors.successColor,
            colorText: Colors.white
        );
        Get.close(2);
      }
    }
    setState(() {
      loading = false;
    });
  }
}
