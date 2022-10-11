import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class StyleConfig {
  static Config emojiConfig = Config(
    columns: 7,
    // Issue: https://github.com/flutter/flutter/issues/28894
    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
    verticalSpacing: 0,
    horizontalSpacing: 0,
    gridPadding: EdgeInsets.zero,
    initCategory: Category.RECENT,
    bgColor: const Color(0xFFF2F2F2),
    indicatorColor: AppColors.primaryColor,
    iconColor: Colors.grey,
    iconColorSelected: AppColors.primaryColor,
    backspaceColor: AppColors.primaryColor,
    skinToneDialogBgColor: Colors.white,
    skinToneIndicatorColor: Colors.grey,
    enableSkinTones: true,
    showRecentsTab: true,
    recentsLimit: 28,
    replaceEmojiOnLimitExceed: false,
    noRecents: const Text(
      'No Recents',
      style: TextStyle(fontSize: 20, color: Colors.black26),
      textAlign: TextAlign.center,
    ),
    loadingIndicator: const SizedBox.shrink(),
    tabIndicatorAnimDuration: kTabScrollDuration,
    categoryIcons: const CategoryIcons(),
    buttonMode: ButtonMode.CUPERTINO,
    checkPlatformCompatibility: true,
  );
}