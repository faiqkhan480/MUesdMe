import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../components/custom_header.dart';
import '../utils/app_colors.dart';
import '../utils/page_manager.dart';
import '../utils/style_config.dart';
import '../widgets/button_widget.dart';
import '../widgets/wave_slider.dart';

class AudioMixingScreen extends StatefulWidget {
  final String? audio;
  const AudioMixingScreen({Key? key, this.audio}) : super(key: key);

  @override
  State<AudioMixingScreen> createState() => _AudioMixingScreenState();
}

class _AudioMixingScreenState extends State<AudioMixingScreen> with WidgetsBindingObserver {
  String? get audioPath => widget.audio;

  final _player = AudioPlayer();

  late final PageManager _pageManager;

  double start = 0;
  double end = -0;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(widget.audio!);
    // ambiguate(WidgetsBinding.instance)!.addObserver(this);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));
    // _init();
  }

  Future<void> _init() async {
    debugPrint("INIT PAGE MANAGER $audioPath}");
    File file = File(audioPath!);

    var a = await file.exists();
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          debugPrint('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      File file = File(audioPath!);
      // await _player.setFilePath(file.path);

      // Define the playlist
      final playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder(),
        // Specify the playlist items,
        children: [
          AudioSource.uri(Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")),
          AudioSource.uri(Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")),
        ],
      );

      // Load and play the playlist
      await _player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);
      // await _player.setAudioSource(
      //     AudioSource.uri(Uri.parse("asset://content:/$url")
      //     // AudioSource.uri(Uri.parse("https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3")
      //     ));
    } catch (e) {
      debugPrint("::::::::::::Error loading audio source: $e");
      Get.snackbar("Error", "$e", backgroundColor: AppColors.primaryColor);
    }
  }

  @override
  void dispose() {
    // ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // // Release decoders and buffers back to the operating system making them
    // // available for other apps to use.
    // _player.dispose();
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomHeader(
            title: "Audio Mixing",
            buttonColor: AppColors.primaryColor,
            showBottom: false,
            showSearch: false,
            showSave: false,
            showRecentWatches: false,
            actions: [
              SmallButton(
                onPressed: _init,
                title: "Reload",
              ),
            ],
          ),

          ControlButtons(_player),

          Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: StyleConfig.gradientBackground.copyWith(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      height: Get.height * 0.25,
                      width: Get.height * 0.25,
                      child: const Icon(Entypo.beamed_note, color: AppColors.secondaryColor, size: 100),
                    ),

                    const SizedBox(height: 50),

                    Row(
                      children: [
                        // Display play/pause button and volume/speed sliders.
                        ValueListenableBuilder<ButtonState>(
                          valueListenable: _pageManager.buttonNotifier,
                          builder: (_, value, __) {
                            switch (value) {
                              case ButtonState.loading:
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 32.0,
                                  height: 32.0,
                                  child: const CircularProgressIndicator(),
                                );
                              case ButtonState.paused:
                                return IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  iconSize: 32.0,
                                  onPressed: _pageManager.play,
                                );
                              case ButtonState.playing:
                                return IconButton(
                                  icon: const Icon(Icons.pause),
                                  iconSize: 32.0,
                                  onPressed: _pageManager.pause,
                                );
                            }
                          },
                        ),

                        const SizedBox(width: 20),

                        // Display seek bar. Using StreamBuilder, this widget rebuilds
                        // each time the position, buffered position or duration changes.
                        Expanded(child: ValueListenableBuilder<ProgressBarState>(
                          valueListenable: _pageManager.progressNotifier,
                          builder: (_, value, __) {
                            return ProgressBar(
                              progress: value.current,
                              buffered: value.buffered,
                              total: value.total,
                              onSeek: _pageManager.seek,
                            );
                          },
                        )),
                      ],
                    ),

                    ValueListenableBuilder<ProgressBarState>(
                      valueListenable: _pageManager.progressNotifier,
                      builder: (context, value, __) {
                        return WaveSlider(
                          backgroundColor: Colors.grey.shade300,
                          heightWaveSlider: 100,
                          widthWaveSlider: 300,
                          duration: value.total.inSeconds.toDouble(),
                          callbackStart: (duration) {
                            setState(() {
                              start = duration;
                              if(end == -0) {
                                end = value.total.inSeconds.toDouble();
                              }
                              // end = value.total.inSeconds.toDouble();
                            });
                            debugPrint("Start DURATION:::::::::: ${Duration(seconds: duration.toInt())}");
                            debugPrint("Start:::::::::: ${Duration(seconds: duration.toInt())}");
                            _pageManager.seek(Duration(seconds: duration.toInt()));
                            clipAudio();
                            // _pageManager.setClip(start: Duration(seconds: duration.toInt()), end: Duration(seconds: endDuration.toInt()));
                          },
                          callbackEnd: (duration) {
                            setState(() {
                              end = duration;
                            });
                            debugPrint("End DURATION:::::::::: ${Duration(seconds: duration.toInt())}");
                            debugPrint("End:::::::::: ${Duration(seconds: duration.toInt())}");
                            _pageManager.seek(Duration(seconds: start.toInt()));
                            clipAudio();
                            // _pageManager.setClip(start: Duration(seconds: start.toInt()), end: Duration(seconds: end.toInt()));
                          },
                        );
                      },
                    )


                    // StreamBuilder<PositionData>(
                    //   stream: _positionDataStream,
                    //   builder: (context, snapshot) {
                    //     final positionData = snapshot.data;
                    //     return SeekBar(
                    //       duration: positionData?.duration ?? Duration.zero,
                    //       position: positionData?.position ?? Duration.zero,
                    //       bufferedPosition:
                    //       positionData?.bufferedPosition ?? Duration.zero,
                    //       onChangeEnd: _player.seek,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
          )
        ],
      ),

        floatingActionButton: FloatingActionButton(
          onPressed: addAudio,
          child: const Icon(FontAwesome5Solid.plus),
        )
    );
  }

  clipAudio() {
    _pageManager.setClip(start: Duration(seconds: start.toInt()), end: Duration(seconds: end.toInt()));
  }

  addAudio() async {
    // FilePickerResult? audio = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.audio);
    //
    // if(audio != null) {
    //   File file = File(audioPath!);
    //   await _player.setAudioSource(ConcatenatingAudioSource(
    //     // Start loading next item just before reaching it.
    //     useLazyPreparation: true, // default
    //     // Customise the shuffle algorithm.
    //     shuffleOrder: DefaultShuffleOrder(), // default
    //     // Specify the items in the playlist.
    //     children: [
    //       AudioSource.uri(Uri.parse("https://example.com/track1.mp3")),
    //       AudioSource.uri(Uri.parse("https://example.com/track2.mp3")),
    //       AudioSource.uri(Uri.parse("https://example.com/track3.mp3")),
    //     ],
    //
    //   ));
    // }
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Feather.volume_2),
          onPressed: () {},
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(AntDesign.playcircleo),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(AntDesign.pausecircleo),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay_rounded),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {

            },
          ),
        ),
      ],
    );
  }
}

