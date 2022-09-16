import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 50),
      // padding: EdgeInsets.symmetric(),
      // alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(Assets.iconsLive, color: AppColors.successColor),
                      const SizedBox(width: 5,),
                      const TextWidget("Live invitation", color: AppColors.successColor, weight: FontWeight.normal),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          backgroundImage: NetworkImage(Constants.albumArt)),
                      SizedBox(width: 10,),
                      Expanded(child: TextWidget("Max Anderson has just sent you invitation to be live with him.", weight: FontWeight.normal, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () => null,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.successColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.iconsLive, height: 10, color: Colors.white),
                  const SizedBox(height: 5,),
                  const TextWidget("Accept\ninvite",
                    color: Colors.white,
                    align: TextAlign.center,
                    size: 10,
                    weight: FontWeight.normal,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
