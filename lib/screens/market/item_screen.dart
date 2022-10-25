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
  int get currIndex => controller.currIndex.value;
  double? get height => controller.height.value;
  double get width => controller.width.value;
  bool get buy => controller.buy.value;
  bool get _loading => controller.loading();

  PaletteGenerator? get palette => controller.palette.value;

  List<Listing?> get _listing => controller.listing;

  @override
  Widget build(BuildContext context) {
    debugPrint("::::::::::::::::::::${selectedItem?.files?.length}");
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
                // child: Hero(
                //   tag: heroKey,
                //   child: Image.network(
                //     "${Constants.LISTING_URL}${_listing.elementAt(Get.arguments)?.mainFile}",
                //     loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
                //     errorBuilder: (context, error, stackTrace) => Container(
                //         decoration: const BoxDecoration(
                //           color: AppColors.secondaryColor,
                //         ),
                //         child: const Icon(Feather.image, color: Colors.white, size: 100,)),
                //     fit: BoxFit.cover, height: double.infinity, width: double.infinity,),
                // ),
              ),

              _files(),

              _sheet(),

              _buyButton(),

              _headerBar(),
            ],
          ),),
        ),
    );
  }

  Widget _files() {
    String heroKey = "pop${Get.arguments}";
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      height: height,
      width: 500,
      left: buy ? 0 : -100,
      curve: Curves.linearToEaseOut,
      child: Hero(
        tag: heroKey,
        child: PageView.builder(
          itemCount: selectedItem?.files?.length ?? 1,
          onPageChanged: (value) => controller.updatePaletteGenerator(selectedItem?.files?.elementAt(value).filePath, value),
          itemBuilder: (context, index) => Image.network(
            "${Constants.LISTING_URL}${ selectedItem?.files?.elementAt(index).filePath ?? _listing.elementAt(Get.arguments)?.mainFile}",
            loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
            errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                ),
                child: const Icon(Feather.image, color: Colors.white, size: 100,)),
            fit: BoxFit.cover, height: double.infinity, width: double.infinity,),

        ),
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
        child: _loading ?
        const SizedBox(
          height: 90,
          child: Loader(),
        ) :
        TextButton(
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
    )
    );
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
            child: Obx(() {
              Color paletteColor = palette?.mutedColor?.color ?? AppColors.secondaryColor;
              Color textColor = (paletteColor.computeLuminance() > 0.179)? AppColors.lightGrey : Colors.black;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      paletteColor.withOpacity(0.3),
                      paletteColor.withOpacity(0.3),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                selectedItem?.userDetails?.profilePic != null && selectedItem!.userDetails!.profilePic!.isNotEmpty ?
                                "${Constants.IMAGE_URL}${selectedItem!.userDetails!.profilePic!}" :
                                Constants.dummyImage,
                                selectedItem!.userId.toString(),
                                padding: const EdgeInsets.all(5.0),
                                badgeContent: null,
                                radius: 20,
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(selectedItem?.userDetails?.fullName ?? "", size: 16, weight: FontWeight.w600),
                                  TextWidget(
                                      selectedItem?.type == "Selling" ? "Selling to you" : "Licensed to you ",
                                      color: AppColors.lightGrey, weight: FontWeight.w400, size: 12),
                                ],
                              ),
                              const Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${Constants.LISTING_URL}${ selectedItem?.files?.elementAt(currIndex).filePath ?? _listing.elementAt(Get.arguments)?.mainFile}",
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

                          const Divider(height: 30),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextWidget("Total Amount", color: AppColors.lightGrey, weight: FontWeight.w400, size: 12),
                              // Spacer(),
                              RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Larsseit"
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${selectedItem?.price}",
                                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                                        ),
                                        const TextSpan(
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
                    ),

                    Container(
                      decoration: BoxDecoration(
                          color: paletteColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
                      margin: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextWidget("Description",
                              color: textColor,
                              weight: FontWeight.w400, size: 14, align: TextAlign.center),
                          const Divider(height: 30),

                          TextWidget(
                              selectedItem?.description ?? "",
                              color: textColor,
                              weight: FontWeight.w400, size: 16, align: TextAlign.start),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
    );
  }
}
