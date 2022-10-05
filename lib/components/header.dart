import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:musedme/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';


import '../utils/assets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_widget.dart';

final List<String> names = ["+ Upload", "Maxwell", "Cristina" , "Dancy", "Andreana", "Andreana"];

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    this.showLives = false,
    this.showShadow = true,
    this.isProfile = false,
    this.height,
    this.handleSearch,
    this.action
  }) : super(key: key);

  final String title;
  final bool showLives;
  final bool showShadow;
  final bool isProfile;
  final double? height;
  final VoidCallback? action;
  final VoidCallback? handleSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: showShadow ? [const BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8
          )] : null
      ),
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: showLives ? 0 : 10, top: 30),
            child: Row(
              children: [
                Image.asset(Assets.iconsLogo, height: 40),
                const SizedBox(width: 20,),
                Text(title, style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Larsseit',
                  fontWeight: FontWeight.w500,
                ),
                ),
                const Spacer(),
                if(!isProfile)
                  TextButton(
                      onPressed: handleSearch,
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                          ),
                          elevation: 2,
                          shadowColor: AppColors.shadowColor.withOpacity(0.3),
                          minimumSize: const Size(50, 15),
                          textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                      ),
                      child: const Icon(CupertinoIcons.search, color: AppColors.secondaryColor),
                  ),
                const SizedBox(width: 15),
                SmallButton(
                  onPressed: action ?? handleLive,
                  title: isProfile ? "Edit Profile" : "Go Live",
                  icon: SvgPicture.asset(isProfile ? Assets.iconsEditProfile : Assets.iconsLive),
                ),
                if(isProfile)...[
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.SETTINGS),
                      // Navigator.push(context, CupertinoPageRoute(builder: (context) => const SettingScreen(),)),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                          ),
                          minimumSize: const Size(50, 0),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                      ),
                      child: const Icon(CupertinoIcons.gear_solid, color: AppColors.secondaryColor,)
                  ),
                ],
              ],
            ),
          ),
          if(showLives)
            SizedBox(
            height: 100,
            child: ListView.separated(
              itemCount: names.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () =>
                  // index == 0 ?
                  presentEditor(index),
                  // Navigator.push(context, CupertinoPageRoute(builder: (context) => const EditorScreen(),)) :
                  // null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Badge(
                        shape: BadgeShape.square,
                        badgeColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        position: BadgePosition.bottomEnd(end: 3.0, bottom: -3),
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 4),
                        badgeContent: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(Assets.iconsLive, color: AppColors.primaryColor, height: 8),
                            const SizedBox(width: 2,),
                            const TextWidget("Live", color: AppColors.primaryColor, weight: FontWeight.normal, size: 10),
                          ],
                        ),
                        showBadge: index == 1 || index == 3,
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.pinkColor),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColors.pinkColor,
                                    // spreadRadius: 2,
                                    blurRadius: 2
                                )]
                          ),
                          padding: const EdgeInsets.all(5),
                          height: 50,
                          width: 50,
                          child:  index == 0 ?
                          Center(child: SvgPicture.asset(Assets.iconsAdd)) :
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(Constants.dummyImage,
                              fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(names.elementAt(index), style: TextStyle(
                          color: index == 0 ? AppColors.pinkColor : null,
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      ),),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 30,),
            ),
          ),
        ],
      ),
    );
  }

  Future handleLive () async {
    await [Permission.camera, Permission.microphone].request();
    Get.toNamed(AppRoutes.LIVE, arguments: {"isBroadcaster": true});
    // Navigator.push(context, CupertinoPageRoute(builder: (context) => const LiveScreen(),));
  }



  void presentEditor(index) async {
    if(index == 0) {
      Get.toNamed(AppRoutes.PICKER);
      // Navigator.push(context, CupertinoPageRoute(builder: (context) => const EditorScreen(),));
    }
  }
}
