import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';

import '../controllers/feed_controller.dart';
import '../screens/collabs_tools/audio_editor.dart';
import '../screens/collabs_tools/audio_merger.dart';
import '../screens/collabs_tools/audio_mixing_screen.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/img_ly_config.dart';
import '../utils/style_config.dart';

class EditorSheet extends StatefulWidget {
  const EditorSheet({Key? key}) : super(key: key);

  @override
  State<EditorSheet> createState() => _EditorSheetState();
}

class _EditorSheetState extends State<EditorSheet> {

  FeedController get controller => Get.find<FeedController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: StyleConfig.gradientBackground,
      child: Column(
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear)),
              const Spacer(flex: 2,),
              const Text("Collaboration Tools",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 20,
                  fontFamily: 'Larsseit',
                  fontWeight: FontWeight.w600,
                ),),

              // const SizedBox.shrink(),
              const Spacer(flex: 3,),
            ],
          ),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: .9
              ),
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => TextButton(
                onPressed: () => _handleClick(index),
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                    textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon(
                    //     index == 1 ?
                    //     Feather.film :
                    //     index == 2 ?
                    //     Feather.scissors :
                    //     index == 3 ?
                    //     Feather.music :
                    //     Feather.image,
                    //     size: 80,
                    //     color: Colors.white),
                    SvgPicture.asset(
                        index == 1 ?
                        Assets.iconsVideoEdit :
                        index == 2 ?
                        Assets.iconsAudioCutter :
                        index == 3 ?
                        Assets.iconsAudioMerge :
                        Assets.iconsImageEdit,
                      height: 80,
                      color: Colors.white,
                    ),
                    // const SizedBox(height: 5,),
                    Text((index == 1 ?
                        "Video Editor" :
                        index == 2 ?
                        "Audio cutter" :
                        index == 3 ?
                        "Audio merger" :
                        "Image editor").toUpperCase()
                    ),
                  ],
                ),
              ),
            ),
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       TextButton(
            //         onPressed: _handleImage,
            //         style: TextButton.styleFrom(
            //             backgroundColor: AppColors.secondaryColor,
            //             foregroundColor: Colors.white,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10)
            //             ),
            //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            //             textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
            //         ),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Icon(Feather.image, color: Colors.white),
            //             // SvgPicture.asset(Assets.iconsDelete),
            //             const SizedBox(width: 5,),
            //             Text("Choose Image".toUpperCase()),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 50,),
            //       TextButton(
            //         onPressed: _handleVideo,
            //         style: TextButton.styleFrom(
            //             backgroundColor: AppColors.secondaryColor,
            //             foregroundColor: Colors.white,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10)
            //             ),
            //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            //             textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
            //         ),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Icon(Feather.film, color: Colors.white),
            //             // SvgPicture.asset(Assets.iconsDelete),
            //             const SizedBox(width: 5,),
            //             Text("Choose Video".toUpperCase()),
            //           ],
            //         ),
            //       ),
            //       if(kDebugMode) ...[
            //         const SizedBox(height: 50,),
            //         TextButton(
            //           onPressed: _handleAudio,
            //           style: TextButton.styleFrom(
            //               backgroundColor: AppColors.secondaryColor,
            //               foregroundColor: Colors.white,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(10)
            //               ),
            //               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            //               textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
            //           ),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.end,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               const Icon(Feather.music, color: Colors.white),
            //               // SvgPicture.asset(Assets.iconsDelete),
            //               const SizedBox(width: 5,),
            //               Text("Choose Audio".toUpperCase()),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  _handleClick(int index) {
    switch (index) {
      case 0:
        _handleImage();
        break;
      case 1:
        _handleVideo();
        break;
      case 2:
        _handleAudioCutter();
        break;
      case 3:
        Get.to(() => const AudioMerger());
        break;
    }
  }


  _handleImage() async {
    FilePickerResult? img = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);
    if(img != null) {
      PhotoEditorResult? result = await PESDK.openEditor(image: img.files.single.path, configuration: ImgLy.createConfiguration());
      if(result != null) {
        controller.handleLocalDownload(result.image, false);
      }
    }
  }

  _handleVideo() async {
    // if(video != null && video!.isNotEmpty) {
    FilePickerResult? vid = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.video);
    if(vid != null) {
      var result = await VESDK.openEditor(Video(vid.files.single.path!), configuration: ImgLy.createConfiguration());
      if(result != null) {
        controller.handleLocalDownload(result.video, true);
      }
    }
  }

  _handleAudioCutter() async {
    FilePickerResult? audio = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.audio);
    //
    if(audio != null) {
      Get.to(() => AudioEditor(audio: audio.files.single.path!));
      //   Get.to(AudioMixingScreen(audio: audio.files.single.path ?? "",));
    }


  }
}
