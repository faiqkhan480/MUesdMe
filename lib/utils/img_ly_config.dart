import 'package:imgly_sdk/imgly_sdk.dart';

import 'assets.dart';


class ImgLy {
  // IMAGE EDITOR CONFIGURATION
  static Configuration createConfiguration() {
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
}