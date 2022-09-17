import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../components/news_card.dart';
import '../components/search_field.dart';
import '../components/title_row.dart';
import '../components/trending_card.dart';
import '../utils/assets.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/image_widget.dart';
import '../widgets/text_widget.dart';

final List<String> filters = [
  "Trending videos",
  "People",
  "Environment",
  "Entertainment",
];

final List<Color> filterColors = [
  AppColors.purpleScale,
  AppColors.orange,
  AppColors.green,
  AppColors.blue,
];

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  // alignment: AlignmentDirectional.center,
                  children: [
                    const SizedBox(
                        height: 400,
                        child: ImageWidget(url: Constants.albumArt, borderRadius: 0,)),
                        // child: Image.network(Constants.albumArt, fit: BoxFit.cover,)),

                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: const [
                          GlassMorphism(
                            start: 0.3,
                            end: 0.3,
                            child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 60),),
                          SizedBox(height: 20,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: TextWidget("Obama orders Policy for agencies", size: 30, color: Colors.white, align: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: const [
                      Expanded(child: NewsCard()),
                      VerticalDivider(width: 1),
                      Expanded(child: NewsCard()),
                    ],
                  ),
                ),

                const TitleRow(title: "Trending videos"),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TrendingCard(itemWidth: 500,),
                ),

                const TitleRow(title: "Popular Categories"),

                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                    ),
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      // color: Colors.green,
                        image: DecorationImage(image: NetworkImage(
                            index == 0 || index == 3 ? Constants.albumArt : Constants.coverImage
                        ),
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                            fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget("The Magic Whip", color: Colors.white, size: 18, weight: FontWeight.w700,),
                        const SizedBox(height: 5,),
                        TextWidget("147 Videos", color: Colors.white.withOpacity(0.8), size: 11, weight: FontWeight.normal,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 10, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () => null,
                        iconSize: 76,
                        padding: EdgeInsets.zero,
                        splashRadius: 2,
                        constraints: const BoxConstraints(maxHeight: 60),
                        icon: SvgPicture.asset(Assets.iconsFilter, height: 80, fit: BoxFit.cover)
                    ),
                    const Expanded(child: SearchField(iconColor: AppColors.secondaryColor, placeHolder: "Type here to search & discover everything...")),
                  ],
                ),

                SizedBox(
                  height: 55,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemBuilder: (context, index) => TextButton(
                          onPressed: () => null,
                        style: TextButton.styleFrom(
                          foregroundColor: filterColors.elementAt(index),
                          backgroundColor: filterColors.elementAt(index).withOpacity(0.3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16)
                        ),
                          child: Text(filters.elementAt(index)),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(width: 10,),
                      itemCount: filters.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
