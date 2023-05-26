import 'dart:io';

import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../components/custom_header.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_config.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/loader.dart';

class AudioEditor extends StatefulWidget {
  final String audio;
  const AudioEditor({Key? key, required this.audio}) : super(key: key);

  @override
  State<AudioEditor> createState() => _AudioEditorState();
}

class _AudioEditorState extends State<AudioEditor> {
  String inputFileView = 'input file path';
  File inputFile = File('');
  File outputFile = File('');
  RangeValues cutValues = const RangeValues(0, 5);
  int timeFile = 10;
  final player = AudioPlayer();
  final outputPlayer = AudioPlayer();
  bool previewPlay = false;
  bool outputPlay = false;
  bool isCutting = false;
  bool isCut = false;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onPickFile();
  }

  @override
  void dispose() {
    player.dispose();
    outputPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomHeader(
            title: "Audio Cutter",
            buttonColor: AppColors.primaryColor,
            showBottom: false,
            showSearch: false,
            showSave: false,
            showRecentWatches: false,
            actions: [
              SmallButton(
                onPressed: _onCut,
                title: "Save",
              ),
            ],
          ),

          Flexible(
            child: Center(
              child: loading ?
              const Loader() :
              RangeSlider(
                  values: cutValues,
                  max: timeFile.toDouble(),
                  divisions: timeFile,
                  labels: RangeLabels(
                      _getViewTimeFromCut(cutValues.start.toInt()).toString(),
                      _getViewTimeFromCut(cutValues.end.toInt()).toString()),
                  onChanged: (values) {
                    setState(() => cutValues = values);
                    player.seek(Duration(seconds: cutValues.start.toInt()));
                  }),
              // child: SingleChildScrollView(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Text(
              //         'INPUT',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       Text(
              //         inputFileView,
              //         textAlign: TextAlign.center,
              //       ),
              //       MaterialButton(
              //         onPressed: _onPickFile,
              //         color: Colors.blue,
              //         child: const Text('Pick file'),
              //       ),
              //       const Divider(),
              //       const Text(
              //         'CUTTER',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       RangeSlider(
              //           values: cutValues,
              //           max: timeFile.toDouble(),
              //           divisions: timeFile,
              //           labels: RangeLabels(
              //               _getViewTimeFromCut(cutValues.start.toInt()).toString(),
              //               _getViewTimeFromCut(cutValues.end.toInt()).toString()),
              //           onChanged: (values) {
              //             setState(() => cutValues = values);
              //             player.seek(Duration(seconds: cutValues.start.toInt()));
              //           }),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Text(
              //               'Start: ${_getViewTimeFromCut(cutValues.start.toInt())}'),
              //           Text('End: ${_getViewTimeFromCut(cutValues.end.toInt())}'),
              //         ],
              //       ),
              //       IconButton(
              //           onPressed: _onPlayPreview,
              //           icon:
              //           Icon(previewPlay ? Icons.stop_circle : Icons.play_arrow)),
              //       MaterialButton(
              //         onPressed: _onCut,
              //         color: Colors.blue,
              //         child: const Text('Cut'),
              //       ),
              //       const Divider(),
              //       const Text(
              //         'OUTPUT',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       isCutting
              //           ? Column(
              //         children: const [
              //           CircularProgressIndicator(),
              //           Text('Waitting...')
              //         ],
              //       )
              //           : Column(
              //         children: [
              //           Text(isCut ? 'Done!' : ''),
              //           Text(isCut ? outputFile.path : 'output file path'),
              //           Text(
              //               'Time: ${outputPlayer.duration?.inMinutes ?? 0}:${outputPlayer.duration?.inSeconds ?? 0}'),
              //           IconButton(
              //               onPressed: _onOutputPlayPreview,
              //               icon: Icon(outputPlay
              //                   ? Icons.stop_circle
              //                   : Icons.play_arrow)),
              //         ],
              //       )
              //     ],
              //   ),
              // ),
            ),
          ),
        ],
      ),

        bottomNavigationBar: Container(
          height: 80,
          decoration: StyleConfig.gradientBackground,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start:\n ${_getViewTimeFromCut(cutValues.start.toInt())}", style:
              const TextStyle(color: Colors.white),),
              IconButton(
                  onPressed: _onPlayPreview,
                  color: Colors.white,
                  iconSize: 60,
                  icon: Icon(previewPlay ? Ionicons.pause_circle : Ionicons.play_circle)
              ),

              Text("End:\n${_getViewTimeFromCut(cutValues.end.toInt())}", style:
              const TextStyle(color: Colors.white),),
            ],
          ),
        ),
    );
  }

  Future<void> _onPickFile() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['mp3'],
    // );
    // if (result != null) {
      inputFile = File(widget.audio);
      await player.setFilePath(inputFile.path);
      setState(() {
        timeFile = player.duration!.inSeconds;
        cutValues = RangeValues(0, timeFile.toDouble());
        inputFileView = inputFile.path;
        loading = false;
      });
    // }
  }

  _getViewTimeFromCut(int index) {
    int minute = index ~/ 60;
    int second = index - minute * 60;
    return "$minute:$second";
  }

  void _onPlayPreview() {
    if (inputFile.path != '') {
      setState(() => previewPlay = !previewPlay);
      if (player.playing) {
        player.stop();
      } else {
        player.seek(Duration(seconds: cutValues.start.toInt()));
        player.play();
      }
    }
  }

  Future<void> _onCut() async {
    if (inputFile.path != '') {
      setState(() => isCutting = true);
      // var result = await AudioCutter.cutAudio(inputFile.path, cutValues.start, cutValues.end);
      var result = await cutAudio(inputFile.path, cutValues.start, cutValues.end);
      outputFile = File(result);
      await outputPlayer.setFilePath(result);
      setState(() {
        isCut = true;
        isCutting = false;
      });
      _saveCutFile();
    }
  }

  _saveCutFile() async {
    if(await Permission.storage.isGranted){
      // String? dir;
      // if(Platform.isAndroid) {
      //   dir = "/storage/emulated/0/Download/";
      //   // dir = (await getApplicationDocumentsDirectory())?.path;
      // } else if(Platform.isIOS) {
      //   dir = (await getApplicationDocumentsDirectory()).path;
      // }

      // var a = await Directory(dir!).exists();

      Uint8List data = outputFile.readAsBytesSync();

      await FlutterFileSaver().writeFileAsBytes(
        fileName: 'CutFile.mp3',
        bytes: data,
      ).then((value) {
        debugPrint(":::::::::${value}");
        if(value != "Unknown") {
          Get.snackbar("FIle Saved!", "File is saved in device.", backgroundColor: AppColors.successColor, colorText: Colors.white);
        }
        // return
      });

    } else{
      debugPrint("No permission to read and write.");
    }
  }

  Future<String> cutAudio(String path, double start, double end) async {
    if (start < 0 || end < 0) {
      throw ArgumentError('The starting and ending points cannot be negative');
    }
    if (start > end) {
      throw ArgumentError(
          'The starting point cannot be greater than the ending point');
    }

    final Directory dir = await getTemporaryDirectory();
    final outPath = "${dir.path}/audio_cutter/output.mp3";
    await File(outPath).create();

    var cmd =
        "-y -i \"$path\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec copy $outPath";
    await FFmpegKit.execute(cmd);

    return outPath;
  }

  void _onOutputPlayPreview() {
    if (outputFile.path != '') {
      setState(() => outputPlay = !outputPlay);
      if (outputPlayer.playing) {
        print("stop");
        outputPlayer.stop();
      } else {
        print("play");
        outputPlayer.play();
      }
    }
  }
}
