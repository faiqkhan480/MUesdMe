import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/generated/assets.dart';
import 'package:musedme/utils/app_colors.dart';

import '../components/feed_card.dart';
import '../utils/constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<String> names = ["+ Upload", "Maxwell", "Cristina" , "Dancy", "Andreana", "Andreana"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(),
          const SizedBox(height: 20,),
          Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) => const FeedCard(),
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemCount: 4
              )
          ),
        ],
      ),
    );
  }

  Widget header() {
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
                const Text("Live Feed", style: TextStyle(
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
