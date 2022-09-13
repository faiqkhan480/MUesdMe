import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/screens/feed_screen.dart';
import 'package:musedme/utils/app_colors.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../generated/assets.dart';
import '../screens/profile_screen.dart';
import '../screens/videos_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<String> menu = ["Feed", "Videos", "Favorites", "Messages", "Profile"];
  int currIndex = 4;

  void handleTap(int index) {
    setState(() {
      currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currIndex,
        children: [
          const FeedScreen(),
          const VideosScreen(),
          Container(),
          Container(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              // spreadRadius: 3,
              blurRadius: 5
            )
          ]
        ),
        child: SizedBox(
          height: 64,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: List.generate(menu.length, (index) => Expanded(
                child: InkWell(
                  onTap: () => handleTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(Assets.menuIcons.elementAt(index),
                        color: currIndex == index ? AppColors.primaryColor : null,
                      ),
                      const SizedBox(height: 10,),
                      TextWidget(menu.elementAt(index),
                          size: 12,
                        color: currIndex == index ? AppColors.primaryColor : null,
                      ),
                      Icon(Icons.circle,
                        size: 4,
                        color: currIndex == index ? AppColors.primaryColor : Colors.white,
                      )
                    ],
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
