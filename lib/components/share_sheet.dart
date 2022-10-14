import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/feed.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/loader.dart';
import '../widgets/video_widget.dart';

class ShareSheet extends StatefulWidget {
  final Feed feed;
  const ShareSheet({Key? key, required this.feed}) : super(key: key);

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  Feed get feed => widget.feed;

  // late CachedVideoPlayerController controller;

  bool loading = false;
  String value = "Public";

  final ApiService _apiService = Get.find<ApiService>();

  @override
  void initState() {
    // if(feed.feedType == "Video") {
    //   controller = CachedVideoPlayerController.network("${Constants.FEEDS_URL}${feed.feedPath}");
    //   controller.initialize().then((value) {
    //     // controller.play();
    //     setState(() {});
    //   });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: <Widget>[
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear)),
                const SizedBox(width: 10),
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: ["Public", "Friends", "Only me"].map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )).toList(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      // onChanged: onChange,
                      onChanged: (d) async {
                        setState(() {
                          value = d!;
                        });
                      },
                      value: value,
                      // value: selectedVideo,
                    )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  loading ?
                  const SizedBox(height: 80,
                      width: 50,
                      child: Loader()) :
                  SmallButton(
                    onPressed: share,
                    title: "Share",
                  ),
                )
              ],
            ),

            const SizedBox(height: 30),
            feed.feedType == "Video" ?
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer.network(
                  "${Constants.FEEDS_URL}${feed.feedPath}",
                  betterPlayerConfiguration: const BetterPlayerConfiguration(
                      aspectRatio: 16 / 9,
                      controlsConfiguration: BetterPlayerControlsConfiguration(
                          // showControls: false,
                        enableFullscreen: false,
                        showControlsOnInitialize: true,
                        enablePlaybackSpeed: false,
                        enableProgressBar: false,
                        enableOverflowMenu: false,
                        enableProgressText: false,
                        enablePip: false,
                        enableSkips: false,
                        overflowModalColor: Colors.transparent,
                        loadingWidget: Loader()
                      )
                  ),
                ),
              ),
            ) :
            // VideoWidget(
            //     url: "${Constants.FEEDS_URL}${feed.feedPath}",
            //     controller: controller,
            //     // controller: _controller.videos.first!,
            //     play: false
            // ) :
            ImageWidget(
              url: "${Constants.FEEDS_URL}${feed.feedPath}",
              height: 250,
            ),
          ],
        ),
      ),
    );
  }

  Future share() async {
    setState(() => loading = true);
    var res = await _apiService.shareFeed(feed.feedId.toString(), value);
    setState(() => loading = false);
  }
}