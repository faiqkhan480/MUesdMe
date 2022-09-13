import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musedme/generated/assets.dart';
import 'package:musedme/widgets/button_widget.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/text_widget.dart';

final List<String> _names = ["Russian Composers", "Guitar Solos", "Workout Rock"];

class TodayPicks extends StatelessWidget {
  const TodayPicks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        itemCount: _names.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: AppColors.pinkColor),
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            if(index == 0)...[
                              const Color(0xffffe259),
                              const Color(0xffffa751),
                            ],

                            if(index == 1)...[
                              const Color(0xff654ea3),
                              const Color(0xffeaafc8),
                            ],

                            if(index == 2)...[
                              const Color(0xffDA4453),
                              const Color(0xff89216B),
                            ]
                          ],
                        )
                        // boxShadow: const [
                        //   BoxShadow(
                        //       color: AppColors.pinkColor,
                        //       // spreadRadius: 2,
                        //       blurRadius: 1
                        //   )]
                    ),
                    padding: const EdgeInsets.all(18),
                    height: 150,
                    width: 150,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(Constants.coverImage,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.dstATop,
                    ),
                  ),

                  const GlassMorphism(
                    start: 0.3,
                    end: 0.3,
                    child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              TextWidget(
                _names.elementAt(index),

              ),
              const SizedBox(height: 6,),
              Row(
                children: [
                  SvgPicture.asset(Assets.iconsHeart, height: 18),
                  const SizedBox(width: 5,),
                  const TextWidget("299,154", size: 12, color: AppColors.lightGrey),
                ],
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 30,),
      ),
    );
  }
}
