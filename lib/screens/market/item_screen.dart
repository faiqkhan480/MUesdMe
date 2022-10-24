import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../controllers/market_controller.dart';
import '../../models/listing.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/user_avatar.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  MarketController get controller => Get.find<MarketController>();

  Listing? get selectedItem => controller.selectedItem.value;
  BoxFit get boxFit => controller.boxFit.value;
  Alignment get alignment => controller.alignment.value;
  BorderRadius get borderRadius => controller.borderRadius.value;
  double? get height => controller.height.value;
  double get width => controller.width.value;
  bool get buy => controller.buy.value;

  PaletteGenerator? get palette => controller.palette.value;

  List<Listing?> get _listing => controller.listing;

  @override
  Widget build(BuildContext context) {
    String heroKey = "pop${Get.arguments}";
    return WillPopScope(
      // onWillPop: controller.onWillPop,
      onWillPop: () async {
        controller.resetValues();
        return false;
      },
        child: Scaffold(
          backgroundColor: palette?.dominantColor?.color ?? AppColors.secondaryColor,
          // backgroundColor: AppColors.secondaryColor,
          body: Obx(() => Stack(
            children: [
              SizedBox(
                height: Get.height,
                width: Get.width,
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 1000),
                height: height,
                width: 500,
                left: buy ? 0 : -100,
                // top: 0,
                curve: Curves.linearToEaseOut,
                child: Hero(
                  tag: heroKey,
                  child: Image.network(
                    "${Constants.LISTING_URL}${_listing.elementAt(Get.arguments)?.mainFile}",
                    loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
                        // borderRadius: BorderRadius.circular(20),
                        // border: Border.all(color: AppColors.secondaryColor)
                      ),
                        // alignment: Alignment.center,
                        child: const Icon(Feather.image, color: Colors.white, size: 100,)),
                    // child: Icon(Feather.image, color: AppColors.secondaryColor, size: 40,)),
                    fit: BoxFit.cover, height: double.infinity, width: double.infinity,),
                  // child: Image.network(nft, fit: boxFit, alignment: alignment),
                ),
              ),

              _sheet(),

              _buyButton(),

              _headerBar(),
            ],
          ),),
        ),
    );
  }

  Widget _headerBar() {
    return Positioned(
        top: 40,
        left: 10,
        right: 10,
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // BACK BUTTON
        TextButton(
            onPressed: controller.resetValues,
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
    ));
  }

  Widget _buyButton() {
    return Positioned(
        bottom: 10,
        left: 10,
        right: 10,
        child: TextButton(
      // onPressed: controller.updatePaletteGenerator,
      onPressed: controller.buyItem,
      style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          padding: const EdgeInsets.only(left: 15, right: 5, top: 8, bottom: 8),
          textStyle: const TextStyle(fontSize: 18, fontFamily: Constants.fontFamily)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Buy This"),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle
            ),
            padding: const EdgeInsets.all(15),
            child: const Icon(AntDesign.arrowright),
          )
        ],
      ),
    ));
  }

  Widget _sheet() {
    return AnimatedPositioned(
      height: buy ? Get.height * 0.50 : 0,
        width: Get.width,
        bottom: 0,
      duration: const Duration(milliseconds: 500),
        child: ClipRRect(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (palette?.dominantColor?.color ?? AppColors.secondaryColor).withOpacity(0.3),
                    (palette?.dominantColor?.color ?? AppColors.secondaryColor).withOpacity(0.3),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                // border: Border.all(
                //   width: 1.5,
                //   color: Colors.white.withOpacity(0.2),
                // ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            UserAvatar(
                              "https://i.pinimg.com/564x/cd/32/18/cd3218b69445f9f0bd5eca70f4c0126e.jpg",
                              1.toString(),
                              padding: const EdgeInsets.all(5.0),
                              badgeContent: null,
                              radius: 20,
                            ),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                TextWidget("Adam Nash", size: 16, weight: FontWeight.w600),
                                TextWidget("Licensed to you ", color: AppColors.lightGrey, weight: FontWeight.w400, size: 12),
                              ],
                            ),
                            const Spacer(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // child: Image.network(nft, fit: BoxFit.cover, height: 50),
                              child: Image.network(
                                "${Constants.LISTING_URL}${_listing.elementAt(Get.arguments)?.mainFile}",
                                loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
                                errorBuilder: (context, error, stackTrace) => Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondaryColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Feather.image, color: Colors.white)),
                                fit: BoxFit.cover, height:50, width: 50,),
                              // child: Image.network(nft, fit: boxFit, alignment: alignment),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextWidget("Total Amount", color: AppColors.lightGrey, weight: FontWeight.w400, size: 12),
                            // Spacer(),
                            RichText(
                                text: const TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Larsseit"
                                    ),
                                    children: [
                                    TextSpan(
                                      text: "18.6",
                                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                        text: "  Dollar",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ]
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
