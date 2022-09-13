import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

final List<String> names = ["+ Upload", "Maxwell", "Cristina" , "Dancy", "Andreana", "Andreana"];

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    this.showLives = false,
    this.showShadow = true,
    this.isProfile = false,
    this.action
  }) : super(key: key);

  final String title;
  final bool showLives;
  final bool showShadow;
  final bool isProfile;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: showShadow ? [BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8
          )] : null
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: showLives ? 0 : 10, top: 8),
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
                  ElevatedButton(
                  onPressed: () => null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      shadowColor: AppColors.shadowColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                  ),
                  child: const Icon(CupertinoIcons.search, color: AppColors.secondaryColor),
                ),
                const SizedBox(width: 15),
                TextButton(
                  onPressed: action,
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(isProfile ? Assets.iconsEditProfile : Assets.iconsLive),
                      const SizedBox(width: 5,),
                      Text(isProfile ? "Edit Profile" : "Go Live"),
                    ],
                  ),
                ),
                if(isProfile)...[
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () => null,
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.pinkColor),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.pinkColor,
                                // spreadRadius: 2,
                                blurRadius: 1
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
                    const SizedBox(height: 10,),
                    Text(names.elementAt(index), style: TextStyle(
                        color: index == 0 ? AppColors.pinkColor : null,
                        fontWeight: FontWeight.w500,
                        fontSize: 12
                    ),),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 30,),
            ),
          ),
        ],
      ),
    );
  }
}
