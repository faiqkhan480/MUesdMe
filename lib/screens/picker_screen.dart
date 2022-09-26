import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:imgly_sdk/imgly_sdk.dart' show Configuration, Options, Sticker, StickerCategory, StickerOptions;
import 'package:video_player/video_player.dart';

import '../components/grids.dart';
import '../models/file_model.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late VideoPlayerController _controller;
  List<FileModel?> imageFiles = [];
  List<VideoFile?> videoFiles = [];
  FileModel? selectedImage;
  VideoFile? selectedVideo;
  String? image;
  String? video;
  String? videoPath;
  bool imagePicker = true;
  bool loader = true;

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
        sticker:
        StickerOptions(personalStickers: true, categories: categories));
    return configuration;
  }

  handleNext() {
    if(imagePicker) {
      handleImage();
    }
    else {
      handleVideo();
    }
  }

  // PICKED SELECTED IMAGE & MOVE TO EDITOR
  handleImage() async {
    // debugPrint(image);
    var result = await PESDK.openEditor(image: image, configuration: createConfiguration());
    debugPrint(result.toString());
  }

  handleVideo() {

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
        debugPrint(videoFiles.first!.files!.first.path!);
        _controller = VideoPlayerController.file(File(videoFiles.first!.files!.first.path!));
        await _controller.initialize();
        _controller.play();
        setState(() {
          selectedVideo = videoFiles.first;
          video = videoFiles.first?.files?.first.path;
          loader = false;
        });
        // debugPrint(":::::::::::::::" + selectedVideo.toString());
        // _controller.play();
      }
    }
  }

  Future<void> getData() async {
    await getImagesPath();
    await getVideosPath();
  }

  // onChange(d) async {
  //   debugPrint("CAALLEDD:::::::");
  //   assert((d?.files?.length ?? 0) > 0);
  //   if(d is FileModel) {
  //     image = d.files?.elementAt(0);
  //     setState(() => selectedImage = d);
  //   }
  //   else{
  //     // await _controller.dispose();
  //     // setState(() {
  //     //   _controllers = [];
  //     // });
  //     // _controller = VideoPlayerController.file(File(d!.files!.elementAt(0).path));
  //     // // await _controller.initialize();
  //     // await Future.forEach(d!.files!, (FileElement element) async {
  //     //   VideoPlayerController c = VideoPlayerController.file(File(element.path!));
  //     //   // await c.initialize();
  //     //   _controllers.add(c);
  //     // });
  //     video = d!.files!.elementAt(0).path;
  //     setState(() => selectedVideo = d);
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.clear)
                      ),
                      const SizedBox(width: 10),
                      DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: getItems(),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            // onChanged: onChange,
                            onChanged: (d) async {
                              assert((d?.files?.length ?? 0) > 0);
                              if(d is FileModel) {
                                image = d.files?.elementAt(0);
                                setState(() => selectedImage = d);
                              }
                              else{
                                video = d!.files!.elementAt(0).path;
                                setState(() => selectedVideo = d);
                              }
                            },
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
                  Center(
                    child: _controller.value.isInitialized ?
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ) : const SizedBox.shrink(),
                  ) :
                  const SizedBox.shrink()
              ),
              const Divider(),
              if(loader)
                const CircularProgressIndicator()
              else
                Flexible(
                    child: TabBarView(
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
                          await _controller.dispose();
                          _controller = VideoPlayerController.file(File(path!));
                          await _controller.initialize();
                          _controller.play();
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
    // return videoFiles.map((e) => DropdownMenuItem(
    //   value: e,
    //   child: Text(
    //     e?.folder ?? "",
    //     style: const TextStyle(color: Colors.black),
    //   ),
    // )).toList() ?? [];
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
}
