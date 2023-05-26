import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/chat.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class InvitationCard extends StatelessWidget {
  final Chat? user;
  final VoidCallback? onTap;
  const InvitationCard({Key? key, this.user, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
      padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
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
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          backgroundImage: NetworkImage(
                              user?.profilePic != null && user!.profilePic!.isNotEmpty ?
                              Constants.IMAGE_URL + user!.profilePic! :
                              Constants.dummyImage
                          ),),
                      const SizedBox(width: 10,),
                      Flexible(
                          child: Text("${user?.fullName} has just sent you invitation to be live with him.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.successColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
