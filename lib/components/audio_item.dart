import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/listing.dart';

class AudioItem extends StatefulWidget {
  final Listing listing;
  const AudioItem({Key? key, required this.listing}) : super(key: key);

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  Listing get listing => widget.listing;
  List<AudioPlayer> players = [];
  int selectedPlayerIdx = 0;

  AudioPlayer get selectedPlayer => players[selectedPlayerIdx];
  List<StreamSubscription> streams = [];


  @override
  void initState() {
    super.initState();
    players = List.generate(listing.files?.length ?? 0, (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop));
    players.asMap().forEach((index, player) {
      streams.add(
        player.onPlayerComplete.listen(
              (it) {}
          // => toast(
          //   'Player complete!',
          //   textKey: Key('toast-player-complete-$index'),
          // ),
        ),
      );
      streams.add(
        player.onSeekComplete.listen(
                (it) {}

          //     (it) => toast(
          //   'Seek complete!',
          //   textKey: Key('toast-seek-complete-$index'),
          // ),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var it in streams) {
      it.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
