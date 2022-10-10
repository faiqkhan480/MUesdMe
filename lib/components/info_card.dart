import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/agora_controller.dart';
import '../models/auths/user_model.dart';
import '../utils/assets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/image_widget.dart';
import '../widgets/text_widget.dart';

class InfoCard extends StatelessWidget {
  final User? user;
  final Widget? button;
  final Widget? action;
  const InfoCard({Key? key, this.user, this.button, this.action}) : super(key: key);

  AgoraController get _agora => Get.find<AgoraController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _agora.isUserOnline(user?.userId.toString() ?? ""),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(
                      color: AppColors.grayScale, //AppColors.shadowColor,
                      blurRadius: 4
                  )]
              ),
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 30),
              height:user?.aboutMe == null ? Get.height * 0.40 : null,
              // alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: action ?? const SizedBox(height: 30,)
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget("${user?.firstName} ${user?.lastName}",
                        size: 34,
                        weight: FontWeight.w700,
                      ),
                      button ?? const SizedBox.shrink()
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      TextWidget("@${user?.userName} ",
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

                  TextWidget(user?.aboutMe ?? '',
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
                badgeColor: snapshot.hasData && snapshot.data! ? AppColors.successColor : AppColors.lightGrey,
                child: CircleAvatar(
                  radius: 50,
                  child: ImageWidget(
                    url: "${Constants.IMAGE_URL}${user?.profilePic}",
                    borderRadius: 100,
                    height: 100,
                  ),
                ),
                // child: CircleAvatar(
                //   backgroundImage:
                //   user?.profilePic == null || user!.profilePic!.isEmpty?
                //   null :
                //   NetworkImage("${Constants.IMAGE_URL}${user?.profilePic}"),
                //   radius: 50,
                //   backgroundColor: Colors.white,
                //   child: user?.profilePic == null || user!.profilePic!.isEmpty?
                //   const Icon(CupertinoIcons.person, size: 80,) :
                //   null,
                // ),
              ),
            ),
          ],
        );
      }
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
            TextWidget(index == 0 ? "${user?.followers}" : index == 1 ? "${user?.followings}" : "0",
              size: 22,
              weight: FontWeight.normal,
            ),
          ],
        )),
      ),
    );
  }
}
