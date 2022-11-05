import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  static const url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

  static String? sourcePath;

  late AudioPlayer _audioPlayer;
  PageManager(String url) {
    sourcePath = url;
    _init(url);
  }

  void _init(String path) async {
    _audioPlayer = AudioPlayer();
    File file = File(path);

    await _audioPlayer.setFilePath(file.path);
    // await _audioPlayer.setUrl(url);
    // Define the playlist
    // final playlist = ConcatenatingAudioSource(
    //   // Start loading next item just before reaching it
    //   useLazyPreparation: true,
    //   // Customise the shuffle algorithm
    //   shuffleOrder: DefaultShuffleOrder(),
    //   // Specify the playlist items
    //   children: [
    //     AudioSource.uri(Uri.parse("")),
    //     // AudioSource.uri(Uri.parse('https://example.com/track2.mp3')),
    //     // AudioSource.uri(Uri.parse('https://example.com/track3.mp3')),
    //   ],
    // );

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration != null && oldState.total > totalDuration ? oldState.total : (totalDuration ?? Duration.zero),
        // total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  String? getPath() {
    return sourcePath;
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void setClip({required Duration start, required Duration end,}) {
    _audioPlayer.setClip(start: start, end: end);
  }

  void setSeek({required Duration start, required Duration end,}) {
    _audioPlayer.duration;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }