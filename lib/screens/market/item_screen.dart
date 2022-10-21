import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../controllers/market_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/user_avatar.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  MarketController get controller => Get.find<MarketController>();

  String get nft => controller.nft.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          // borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(nft),
            fit: BoxFit.cover,
            alignment: const Alignment(0.6, 0)
          ),
        ),
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 20),
        child: Column(
          children: [
            // HEADER
            _headerBar(),

            const Spacer(),

            TextButton(
              onPressed: controller.buyItem,
              style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  textStyle: const TextStyle(fontSize: 18, fontFamily: Constants.fontFamily)
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Buy This"),
                  // Spacer(),
                  Icon(AntDesign.arrowright)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _headerBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // BACK BUTTON
        TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                ),
                // padding: const EdgeInsets.symmetric(vertical: 18),
                minimumSize: const Size(45, 0),
                textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
            ),
            child: const Icon(CupertinoIcons.back, color: AppColors.secondaryColor,)
        ),

        // USER IMAGE
        UserAvatar(
          "https://i.pinimg.com/564x/cd/32/18/cd3218b69445f9f0bd5eca70f4c0126e.jpg",
          1.toString(),
          padding: const EdgeInsets.all(5.0),
          badgeContent: null,
          radius: 25,
        ),
      ],
    );
  }
}
