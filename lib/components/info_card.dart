import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../generated/assets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 4
              )]
          ),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () => null,
                    color: AppColors.lightGrey,
                    iconSize: 30,
                    icon: const Icon(CupertinoIcons.ellipsis)
                    // icon: const Icon(Icons.more_horiz_rounded,)
                ),
              ),
              const SizedBox(height: 5,),
              const TextWidget("James\nMartinia Junior",
                size: 34,
                weight: FontWeight.w700,
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const TextWidget("@jamesjunior",
                    size: 14,
                    color: AppColors.lightGrey,
                    weight: FontWeight.w400,
                  ),
                  SvgPicture.asset(Assets.iconsVerified)
                ],
              ),

              staticDataRow(),

              const TextWidget("About me",
                // size: 34,
                color: AppColors.primaryColor,
                weight: FontWeight.normal,
              ),

              const SizedBox(height: 15,),

              const TextWidget("There’s nothing better drive on Golden Gate Bridge the wide strait connecting. #Golden #Bridge",
                weight: FontWeight.normal,
              ),
            ],
          ),
        ),

        Positioned(
          top: -50,
          child: Badge(
            position: BadgePosition.topEnd(top: 5, end: 10),
            elevation: 0,
            padding: const EdgeInsets.all(7),
            borderSide: const BorderSide(color: Colors.white),
            badgeColor: AppColors.successColor,
            child: const CircleAvatar(
              backgroundImage: NetworkImage(Constants.dummyImage),
              radius: 50,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget staticDataRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) => Column(
          children: [
            TextWidget(index == 0 ? "Followers" : index == 1 ? "Following" : "Post uploads",
              color: AppColors.lightGrey,
              weight: FontWeight.normal,
            ),
            TextWidget(index == 0 ? "1.7m" : index == 1 ? "348" : "2k",
              size: 22,
              weight: FontWeight.normal,
            ),
          ],
        )),
      ),
    );
  }
}
