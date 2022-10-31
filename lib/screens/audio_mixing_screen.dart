import 'package:flutter/material.dart';

import '../components/custom_header.dart';
import '../utils/app_colors.dart';

class AudioMixingScreen extends StatefulWidget {
  const AudioMixingScreen({Key? key}) : super(key: key);

  @override
  State<AudioMixingScreen> createState() => _AudioMixingScreenState();
}

class _AudioMixingScreenState extends State<AudioMixingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          CustomHeader(
            title: "Audio Mixing",
            buttonColor: AppColors.primaryColor,
            showBottom: false,
            showSearch: false,
            showSave: false,
            showRecentWatches: false,
          ),
        ],
      ),
    );
  }
}
