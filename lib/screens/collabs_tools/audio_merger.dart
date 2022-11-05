import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/custom_header.dart';
import '../../utils/app_colors.dart';
import '../../utils/page_manager.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/loader.dart';
import '../../widgets/shadowed_box.dart';

class AudioMerger extends StatefulWidget {
  const AudioMerger({Key? key}) : super(key: key);

  @override
  State<AudioMerger> createState() => _AudioMergerState();
}

class _AudioMergerState extends State<AudioMerger> {
  bool loading = false;

  // late final PageManager _pageManager;
  final List<PageManager> _pageManagers = [];
  final List<String> _sounds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: "Audio Merge",
              buttonColor: AppColors.primaryColor,
              showBottom: false,
              showSearch: false,
              showSave: false,
              showRecentWatches: false,
              actions: [
                SmallButton(
                  onPressed: _addAudio,
                  title: "Add Audio",
                ),
              ],
            ),

            Flexible(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ListView.separated(
                    itemCount: _pageManagers.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      separatorBuilder: (context, index) => const SizedBox(height: 20,),
                      itemBuilder: (context, index) => Stack(
                        children: [
                          ShadowedBox(
                            child: Column(
                              children: [
                                // Display play/pause button and volume/speed sliders.
                                ValueListenableBuilder<ButtonState>(
                                  valueListenable: _pageManagers.elementAt(index).buttonNotifier,
                                  builder: (_, value, __) {
                                    switch (value) {
                                      case ButtonState.loading:
                                        return Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: 50.0,
                                          height: 50.0,
                                          child: const CircularProgressIndicator(),
                                        );
                                      case ButtonState.paused:
                                        return IconButton(
                                          icon: const Icon(AntDesign.play),
                                          iconSize: 50.0,
                                          color: AppColors.primaryColor,
                                          onPressed: _pageManagers.elementAt(index).play,
                                        );
                                      case ButtonState.playing:
                                        return IconButton(
                                          icon: const Icon(AntDesign.pausecircle),
                                          color: AppColors.primaryColor,
                                          iconSize: 50.0,
                                          onPressed: _pageManagers.elementAt(index).pause,
                                        );
                                    }
                                  },
                                ),

                                // const SizedBox(width: 20),

                                // Display seek bar. Using StreamBuilder, this widget rebuilds
                                // each time the position, buffered position or duration changes.
                                ValueListenableBuilder<ProgressBarState>(
                                  valueListenable: _pageManagers.elementAt(index).progressNotifier,
                                  builder: (_, value, __) {
                                    return ProgressBar(
                                      progress: value.current,
                                      buffered: value.buffered,
                                      total: value.total,
                                      progressBarColor: AppColors.primaryColor,
                                      timeLabelLocation: TimeLabelLocation.above,
                                      onSeek: _pageManagers.elementAt(index).seek,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(AntDesign.close),
                            // iconSize: 50.0,
                            color: AppColors.secondaryColor,
                            onPressed: () => _deleteItem(index),
                          )
                        ],
                      ),
                  ),
                  
                  if(loading)
                    ClipRRect(
                    child: Container(
                      color: AppColors.secondaryColor.withOpacity(0.3),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: const Center(
                          child: Loader(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        floatingActionButton: _sounds.isEmpty || _sounds.length < 2 ? null : FloatingActionButton(
          onPressed: _mergeAudio,
          child: const Icon(Entypo.merge),
        )
    );
  }

  Future<void> _deleteItem(int index) async {
    _pageManagers.elementAt(index).dispose();
    setState(() {
      _pageManagers.removeAt(index);
      _sounds.removeAt(index);
    });
  }

  Future<void> _mergeAudio() async {
    if(!loading) {
      setState(() => loading = true);
      final Directory dir = await getTemporaryDirectory();
      final outPath = "${dir.path}/merge/output.mp3";
      await File(outPath).create(recursive: true);

      String cmd = "";

      for (var s in _sounds) {
        cmd = '$cmd -i "$s"';
      }

      cmd = "$cmd -filter_complex 'concat=n=2:v=0:a=1[a]' -map '[a]' -c:a libmp3lame -qscale:a 2 $outPath -y";

      // var cmd ="-i ${_sounds.first} -i ${_sounds.last} -filter_complex 'concat=n=2:v=0:a=1[a]' -map '[a]' -c:a libmp3lame -qscale:a 2 $outPath -y";
      // var _cmd ="-i ${Uri.decodeFull(_sounds.first)} -i ${Uri.decodeFull(_sounds.last)} -filter_complex 'concat=n=2:v=0:a=1[a]' -map '[a]' -c:a libmp3lame -qscale:a 2 $outPath -y";

      debugPrint("cmd::::::::::::::$cmd");
      FFmpegKit.executeAsync(cmd, (session) async {
        final returnCode = await session.getReturnCode();
        final logs = await session.getOutput();
        debugPrint("LOGS::::::::::::::$logs");
        if (ReturnCode.isSuccess(returnCode)) {
          // SUCCESS
          _saveCutFile(File(outPath));
        } else if (ReturnCode.isCancel(returnCode)) {
          // // CANCEL
          setState(() => loading = false);
          // Get.snackbar("Cancel", "File merge cancel", backgroundColor: AppColors.primaryColor, colorText: Colors.white);
        } else {
          // ERROR
          setState(() => loading = false);
          Get.snackbar("Error", "Error merge audio", backgroundColor: AppColors.primaryColor, colorText: Colors.white);
        }
        debugPrint("returnCode $returnCode");
      }
      );
    }
  }

  Future<void> _addAudio() async {
    FilePickerResult? mp3 = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.audio);
    if(mp3 != null) {
      setState(() {
        _pageManagers.add(PageManager(mp3.files.single.path!));
        _sounds.add(mp3.files.single.path!);
      });
    }
  }

  _saveCutFile(File file) async {
    if(await Permission.storage.isGranted){
      Uint8List data = file.readAsBytesSync();

      await FlutterFileSaver().writeFileAsBytes(
        fileName: 'Merge_File.mp3',
        bytes: data,
      ).then((value) {
        if(value != "Unknown") {
          Get.snackbar("FIle Saved!", "File is saved in device.", backgroundColor: AppColors.successColor, colorText: Colors.white);
        }
        setState(() => loading = false);
      });
    } else{
      debugPrint("No permission to read and write.");
    }
  }
}
