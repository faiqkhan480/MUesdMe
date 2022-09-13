import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/assets.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        shadowColor: AppColors.shadowColor.withOpacity(0.2),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        fixedSize: const Size(20, 40),
                        textStyle: const TextStyle(
                            fontSize: 12, fontFamily: Constants.fontFamily)),
                    child: const Icon(CupertinoIcons.back,
                        color: AppColors.secondaryColor),
                  ),
                  // TextButton(
                  //     onPressed: () => null,
                  //     style: TextButton.styleFrom(
                  //         backgroundColor: Colors.white,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8),
                  //             side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                  //         ),
                  //         padding: const EdgeInsets.symmetric(vertical: 16),
                  //         textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
                  //     ),
                  //     child: const Icon(CupertinoIcons.gear_solid, color: AppColors.secondaryColor,)
                  // ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Larsseit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.successColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 12,
                            fontFamily: Constants.fontFamily,
                            fontWeight: FontWeight.normal)),
                    child: const Text("Save changes"),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: -55,
          child: CircleAvatar(
            backgroundImage: NetworkImage(Constants.dummyImage),
            radius: 60,
            backgroundColor: Colors.white,
          ),
        ),

        Positioned(
          // left: 0,
          right: 166,
          bottom: -28,
          child: IconButton(
            onPressed: () => null,
            iconSize: 55,
            padding: EdgeInsets.zero,
            splashRadius: 2,
            icon: SvgPicture.asset(Assets.iconsUploadImage, height: 80),
          ),
          // child: Center(
          //   child: InkWell(
          //     onTap: () => null,
          //     borderRadius: BorderRadius.circular(100),
          //     child: Container(
          //       decoration: const BoxDecoration(
          //         // color: AppColors.primaryColor,
          //           shape: BoxShape.circle),
          //       alignment: Alignment.center,
          //       child: SvgPicture.asset(Assets.iconsUploadSvg),
          //     ),
          //   ),
          // )
        )
      ],
    );
  }
}
