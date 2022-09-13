import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../utils/assets.dart';
import '../utils/constants.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextWidget("Messages", size: 28, weight: FontWeight.bold,),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextWidget("You have 2 new messages", color: AppColors.lightGrey, weight: FontWeight.normal,),
            ),

            Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 20, bottom: 0),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color: index == 1 ? AppColors.progressColor : index == 5 ? AppColors.successColor : Colors.white,
                            width: 4
                          )
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: Badge(
                              badgeColor: AppColors.successColor,
                              position: BadgePosition.topEnd(top: -1, end: 4),
                              elevation: 0,
                              showBadge: index == 0 || index == 1 || index == 4,
                              borderSide: const BorderSide(color: Colors.white, width: .7),
                              child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  backgroundImage: NetworkImage(Constants.dummyImage)),
                            ),
                            title: const TextWidget("Julian Dasilva", weight: FontWeight.w800),
                            subtitle: const TextWidget("Hi Julian! See you after work?", size: 12, weight: FontWeight.w500, color: AppColors.lightGrey),
                            trailing: IconButton(
                                onPressed: () => null,
                                icon: SvgPicture.asset(Assets.iconsAdd)
                            )
                          ),
                          if(index == 5)
                            const Divider(color: AppColors.grayScale, thickness: 1, height: 1),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(color: AppColors.grayScale, thickness: 1, height: 1),
                    itemCount: 6
                )
            ),
          ],
        ),
      ),
    );
  }
}
