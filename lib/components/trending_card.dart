import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/generated/assets.dart';
import 'package:musedme/utils/constants.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../widgets/glass_morphism.dart';

class TrendingCard extends StatelessWidget {
  final double? horizontalSpace;
  const TrendingCard({Key? key, this.horizontalSpace}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSpace ?? 0.0),
      child: Badge(
        shape: BadgeShape.square,
        badgeColor: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        position: BadgePosition.topEnd(top: 8, end: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        badgeContent: Row(
          children: [
            SvgPicture.asset(Assets.iconsEye),
            const SizedBox(width: 5,),
            const TextWidget("3m views", color: Colors.white, weight: FontWeight.w300,),
          ],
        ),
        elevation: 0,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                  Constants.coverImage,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.3),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                Constants.coverImage,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const GlassMorphism(
                              start: 0.3,
                              end: 0.3,
                              child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40,),
                            )
                          ]
                        ),
                        const SizedBox(width: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget("FLOW",
                                color: Colors.white.withOpacity(0.4),
                                size: 22,
                                weight: FontWeight.w700
                            ),
                            const TextWidget("Birds flying above the mountain.", color: Colors.white, size: 12, weight: FontWeight.w400,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
