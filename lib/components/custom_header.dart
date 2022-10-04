import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';


import '../components/trending_card.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/assets.dart';
import 'title_row.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key? key,
    required this.title,
    this.showBottom = true,
    this.showRecentWatches = false,
    this.loader = false,
    this.showSearch = false,
    this.showBack = true,
    this.showSave = true,
    this.buttonColor,
    this.img,
    this.onClick,
    this.onSave
  }) : super(key: key);

  final String title;
  final ImageProvider? img;
  final bool showBottom;
  final bool loader;
  final bool showSave;
  final bool showBack;
  final bool showRecentWatches;
  final Color? buttonColor;
  final bool showSearch;
  final VoidCallback? onSave;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          padding: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: showBottom ? 100 : showRecentWatches ? 20 : 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [BoxShadow(
                color: AppColors.grayScale,  //AppColors.shadowColor,
                blurRadius: 8)],
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if(showBack)...[
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                            ),
                            // padding: const EdgeInsets.symmetric(vertical: 18),
                            minimumSize: const Size(45, 0),
                            textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                        ),
                        child: const Icon(CupertinoIcons.back, color: AppColors.secondaryColor,)
                    ),
                    const SizedBox(width: 15,),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Larsseit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if(showSearch)...[
                    TextButton(
                      onPressed: () => null,
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                          ),
                          elevation: 2,
                          shadowColor: AppColors.shadowColor.withOpacity(0.3),
                          minimumSize: const Size(50, 8),
                          textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                      ),
                      child: const Icon(CupertinoIcons.search, size: 22, color: AppColors.secondaryColor),
                    ),
                    const SizedBox(width: 10,),
                  ],
                  if(showSave && loader)
                    SizedBox(
                        height: 40,
                        child: Lottie.asset(Assets.loader))
                  else if(showSave)
                    TextButton(
                    onPressed: onSave,
                    style: TextButton.styleFrom(
                        backgroundColor: buttonColor ?? AppColors.successColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 12,
                            fontFamily: Constants.fontFamily,
                            fontWeight: FontWeight.normal)),
                    child: const Text("Save changes"),
                  ),
                ],
              ),

              if(showRecentWatches)...[
                const TitleRow(title: "Recently watched videos", horizontalSpacing: 0,),

                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => const TrendingCard(itemWidth: 300,),
                      separatorBuilder: (context, index) => const SizedBox(width: 10,),
                      itemCount: 2
                  ),
                ),
              ],
            ],
          ),
        ),

        if(showBottom)...[
          Positioned(
            bottom: -55,
            child: CircleAvatar(
              backgroundImage: img,
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),

          Positioned(
            // left: 0,
            right: 110,
            bottom: -28,
            child: IconButton(
              onPressed: onClick,
              iconSize: 55,
              padding: EdgeInsets.zero,
              splashRadius: 2,
              icon: SvgPicture.asset(Assets.iconsUploadImage, height: 80),
            ),
            // child: Center(
            //   child: InkWell(
            //     onTap: () => null,
            //     borderRadius: BorderRadius.circular(100),
            //     child: Container(
            //       decoration: const BoxDecoration(
            //         // color: AppColors.primaryColor,
            //           shape: BoxShape.circle),
            //       alignment: Alignment.center,
            //       child: SvgPicture.asset(Assets.iconsUploadSvg),
            //     ),
            //   ),
            // )
          )
        ],
      ],
    );
  }
}
