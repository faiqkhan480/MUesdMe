import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

final List<String> names = ["+ Upload", "Maxwell", "Cristina" , "Dancy", "Andreana", "Andreana"];

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    this.showLives = false
  }) : super(key: key);

  final String title;
  final bool showLives;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8
          )]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  onPressed: () => null,
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(Assets.iconsLive),
                      const SizedBox(width: 5,),
                      const Text("Go Live"),
                    ],
                  ),
                ),
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
