import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/generated/assets.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/utils/constants.dart';

import '../widgets/button_widget.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/text_widget.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4
          )]
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Badge(
              badgeColor: AppColors.successColor,
              position: BadgePosition.topEnd(top: -1, end: 4),
              elevation: 0,
              borderSide: const BorderSide(color: Colors.white, width: .7),
              child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  backgroundImage: NetworkImage(Constants.dummyImage)),
            ),
            title: const TextWidget("Cristina Scott", weight: FontWeight.w800),
            subtitle: const TextWidget("California, USA", size: 12, weight: FontWeight.w500, color: AppColors.lightGrey),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                TextWidget("3 min ago", color: AppColors.lightGrey, size: 12),
                SizedBox(width: 10,),
                Icon(Icons.more_horiz_rounded, color: AppColors.lightGrey)
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(Constants.coverImage, height: 250, fit: BoxFit.cover,),
              ),

              const GlassMorphism(
                start: 0.3,
                end: 0.3,
                child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 60),
              )
            ],
          ),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextWidget("There’s nothing better drive on Golden Gate Bridge the wide strait connecting. #Golden #Bridge more"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children:  [
                 ButtonWidget(
                   onPressed: () => null,
                  text: "7.1k",
                  icon: Assets.iconsHeart,
                ),
                 ButtonWidget(
                   onPressed: () => null,
                  text: "34 comments",
                  icon: Assets.iconsComment,
                ),
                 const Spacer(),
                 ButtonWidget(
                  onPressed: () => null,
                  text: "Share",
                  textColor: AppColors.primaryColor,
                  icon: Assets.iconsShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
