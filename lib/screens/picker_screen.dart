import 'dart:convert';
import 'dart:io';


// import 'package:cached_video_player/cached_video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:get/get.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';

import '../components/grids.dart';
import '../models/file_model.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../widgets/button_widget.dart';
import 'upload_screen.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  // BetterPlayerConfiguration? betterPlayerConfiguration;
  // BetterPlayerListVideoPlayerController? controller;

  // BetterPlayerController? _betterPlayerController;

  List<FileModel?> imageFiles = [];
  List<VideoFile?> videoFiles = [];
  FileModel? selectedImage;
  VideoFile? selectedVideo;
  String? image;
  String? video;
  String? videoPath;
  bool imagePicker = true;
  bool loader = true;

  // <___________________BETTER PLAYER CONFIGURATION___________________>
  final GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey = GlobalKey<BetterPlayerPlaylistState>();
  List<BetterPlayerDataSource> _dataSourceList = [];
  late BetterPlayerConfiguration _betterPlayerConfiguration;
  late BetterPlayerPlaylistConfiguration _betterPlayerPlaylistConfiguration;

  BetterPlayerPlaylistController? get _betterPlayerPlaylistController => _betterPlayerPlaylistStateKey.currentState?.betterPlayerPlaylistController;

  _EditorScreenState() {
    _betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 1,
      autoPlay: true,
      fit: BoxFit.cover,
      placeholderOnTop: true,
      showPlaceholderUntilPlay: true,
      subtitlesConfiguration: const BetterPlayerSubtitlesConfiguration(fontSize: 10),
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      eventListener: (e) {
        _betterPlayerPlaylistController?.betterPlayerController?.setVolume(0);
      },
      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false)
    );
    _betterPlayerPlaylistConfiguration = const BetterPlayerPlaylistConfiguration(
      loopVideos: true,
      nextVideoDelay: Duration(seconds: 3),
    );
  }

  // <__________________END_BETTER PLAYER CONFIGURATION___________________>

  // IMAGE EDITOR CONFIGURATION
  Configuration createConfiguration() {
    final flutterSticker = Sticker(
        "example_sticker_logos_flutter", "Flutter", Assets.iconsLogo);
    final imglySticker = Sticker(
        "example_sticker_logos_imgly", "img.ly", Assets.iconsSmileyFace);

    /// A completely custom category.
    final logos = StickerCategory(
        "example_sticker_category_logos", "Logos", Assets.iconsLogo,
        items: [flutterSticker, imglySticker]);

    /// A predefined category.
    final emoticons =
    StickerCategory.existing("imgly_sticker_category_emoticons");

    /// A customized predefined category.
    final shapes =
    StickerCategory.existing("imgly_sticker_category_shapes", items: [
      Sticker.existing("imgly_sticker_shapes_badge_01"),
      Sticker.existing("imgly_sticker_shapes_arrow_02")
    ]);
    final categories = <StickerCategory>[logos, emoticons, shapes];
    final configuration = Configuration(
        sticker: StickerOptions(personalStickers: true, categories: categories),
        audio: AudioOptions(categories:  [
              AudioClipCategory("example_sounds", "SoundHelix", items: [
                AudioClip("Song-1", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
              ])
            ]
        ),
    );
    return configuration;
  }

  handleNext() {
    if(imagePicker) {
      _handleImage();
    }
    else {
      _handleVideo();
    }
  }

  // PICKED SELECTED IMAGE & MOVE TO EDITOR
  _handleImage() async {
    PhotoEditorResult? result = await PESDK.openEditor(image: image, configuration: createConfiguration());
    if(result != null) {
      Get.to(UploadScreen(post: result,));
    }
  }

  _handleVideo() async {
    if(video != null && video!.isNotEmpty) {
      var result = await VESDK.openEditor(Video(video!), configuration: createConfiguration());
      if(result != null) {
        Get.to(UploadScreen(video: result,));
      }
      // debugPrint("${result?.toJson()}");
    }
  }

  Future<void> getImagesPath() async {
    String? imagePath = await StoragePath.imagesPath;
    if(imagePath != null) {
      var images = jsonDecode(imagePath) as List;
      imageFiles = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
      if (imageFiles.isNotEmpty) {
        setState(() {
          selectedImage = imageFiles[0];
          image = imageFiles[0]?.files?.elementAt(0);
        });
      }
    }
  }

  Future<void> getVideosPath() async {
    String? videoPath = await StoragePath.videoPath;
    if(videoPath != null) {
      var videos = jsonDecode(videoPath) as List;
      videoFiles = videos.map<VideoFile>((e) => VideoFile.fromJson(e)).toList();
      if (videoFiles.isNotEmpty) {
        // debugPrint(videoFiles.first!.files!.first.path!);
        for (var f in videoFiles.first!.files!) {
          _dataSourceList.add(
            BetterPlayerDataSource(
              BetterPlayerDataSourceType.file,
              f.path!,
            ),
          );
        }
        _betterPlayerPlaylistController?.betterPlayerController?.setVolume(0);
        setState(() {
          selectedVideo = videoFiles.first;
          video = videoFiles.first?.files?.first.path;
          loader = false;
        });
      }
    }
  }

  Future<void> getData() async {
    await getImagesPath();
    await getVideosPath();
  }

  onChange(d) async {
    assert((d?.files?.length ?? 0) > 0);
    if(d is FileModel) {
      image = d.files?.elementAt(0);
      setState(() => selectedImage = d);
    }
    else{
      video = d!.files!.elementAt(0).path;
      List<BetterPlayerDataSource> list = [];
      for (var f in d!.files!) {
        list.add(
          BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            f.path!,
          ),
        );
      }
      _betterPlayerPlaylistController?.setupDataSourceList(list);
      setState(() => selectedVideo = d);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("image::::::::::: $image");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.clear)
                      ),
                      const SizedBox(width: 10),
                      DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: getItems(),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            onChanged: onChange,
                            // onChanged: (d) async {
                            //
                            // },
                            value: imagePicker ? selectedImage : selectedVideo,
                            // value: selectedVideo,
                          ))
                    ],
                  ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmallButton(
                      onPressed: handleNext,
                      title: "Next",
                    ),
                  )
                ],
              ),
              const Divider(),

              // VIEW BOX
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: imagePicker && image != null ?
                  Image.file(File(image!),
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width
                  ) :
                  !imagePicker && video != null ?
                  videoWidget() :
                  const SizedBox.shrink()
              ),
              const Divider(),
              if(loader)
                const CircularProgressIndicator()
              else
                Flexible(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // IMAGES
                      Grids(
                        onTap: (int i, {String? path}) {
                          setState(() {
                            image = selectedImage?.files?.elementAt(i) as String;
                          });
                        },
                        // controllers: _controllers,
                        items: selectedImage?.files,
                      ),
                      // VIDEOS
                      Grids(
                        onTap: (int i, {String? path}) async {
                          _betterPlayerPlaylistController!.setupDataSource(i);
                          setState(() {
                            video = selectedVideo?.files?.elementAt(i).path;

                          });
                        },
                        items: selectedVideo?.files,
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.black,
              onTap: (value) {
                setState(() => imagePicker = value == 0);
              },
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.5, color: AppColors.primaryColor),
                  insets: EdgeInsets.symmetric(horizontal: 35.0)),
              tabs: List.generate(2, (index) => Tab(
                text: index == 0 ? "Images" : "Videos",
              ))
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem>? getItems() {
    if(imagePicker) {
      return imageFiles.map((e) => DropdownMenuItem(
        value: e,
        child: Text(
          e?.folder ?? "",
          style: const TextStyle(color: Colors.black),
        ),
      )).toList() ?? [];
    }
    else {
      return videoFiles.map((e) => DropdownMenuItem(
        value: e,
        child: Text(
          e?.folder ?? "",
          style: const TextStyle(color: Colors.black),
        ),
      )).toList() ?? [];
    }
  }

  Widget videoWidget() {
    return (_dataSourceList.isNotEmpty) ? Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: BetterPlayerPlaylist(
            key: _betterPlayerPlaylistStateKey,
            betterPlayerConfiguration: _betterPlayerConfiguration,
            betterPlayerPlaylistConfiguration: _betterPlayerPlaylistConfiguration,
            betterPlayerDataSourceList: _dataSourceList,
          ),
        ),
    ) : const SizedBox.shrink();
  }
}
