import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../components/audio_item.dart';
import '../../controllers/market_controller.dart';
import '../../models/listing.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/wallet_button.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  MarketController get controller => Get.find<MarketController>();
  AuthService get _auth => Get.find<AuthService>();

  Listing? get selectedItem => controller.selectedItem.value;
  BoxFit get boxFit => controller.boxFit.value;
  Alignment get alignment => controller.alignment.value;
  BorderRadius get borderRadius => controller.borderRadius.value;
  int get currIndex => controller.currIndex.value;
  double? get height => controller.height.value;
  double get width => controller.width.value;
  bool get buy => controller.buy.value;
  bool get _loading => controller.loading();
  bool get _buying => controller.buying();

  PaletteGenerator? get palette => controller.palette.value;

  List<Listing?> get _listing => controller.listing;

  @override
  Widget build(BuildContext context) {
    // String heroKey = "pop${Get.arguments}";
    bool isMy = selectedItem?.userId != _auth.currentUser?.userId;
    return WillPopScope(
      onWillPop: () async {
       controller.resetValues();
        return !isMy;
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

              _title(),

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
          itemBuilder: (context, index) => selectedItem?.category == 'Video' ?
          _video(index) :
          selectedItem?.category == 'Music' ?
          _audioCard(index) :
          Image.network(
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

  Widget _video(int index) {
    return AspectRatio(
      aspectRatio: 0.5,
      child: BetterPlayerListVideoPlayer(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          // "${Constants.FEEDS_URL}${_listing.elementAt(Get.arguments)?.mainFile}",
          "${Constants.LISTING_URL}${ selectedItem?.files?.elementAt(index).filePath ?? _listing.elementAt(Get.arguments)?.mainFile}",
          notificationConfiguration: BetterPlayerNotificationConfiguration(
            showNotification: false,
            title: _listing.elementAt(Get.arguments)?.title ?? "",
            author: "Test",
          ),
          bufferingConfiguration: const BetterPlayerBufferingConfiguration(
              minBufferMs: 2000,
              maxBufferMs: 10000,
              bufferForPlaybackMs: 1000,
              bufferForPlaybackAfterRebufferMs: 2000),
        ),
        configuration: BetterPlayerConfiguration(
            autoDispose: false,
            looping: true,
            fit: BoxFit.cover,
            autoPlay: true,
            aspectRatio: 0.5,
            eventListener: (p0) {
              if(p0.betterPlayerEventType == BetterPlayerEventType.setVolume) {
                controller.betterCtrl;
              }
            },
            // handleLifecycle: true,
            controlsConfiguration: const BetterPlayerControlsConfiguration(
                enableFullscreen: false,
                showControlsOnInitialize: true,
                enablePlaybackSpeed: false,
                enableProgressBar: false,
                enableOverflowMenu: false,
                enableProgressText: false,
                enablePip: false,
                enableSkips: false,
                // loadingWidget: Loader(),
                controlBarColor: Colors.transparent,
                playIcon: FontAwesome5Solid.play_circle,
                pauseIcon: FontAwesome5Solid.pause_circle,
                muteIcon: FontAwesome5Solid.volume_up,
                unMuteIcon: FontAwesome5Solid.volume_mute,
                enablePlayPause: false
            )
        ),
        //key: Key(videoListData.hashCode.toString()),
        playFraction: 0.8,
        betterPlayerListVideoPlayerController: controller.betterCtrl,
      ),
    );
  }

  Widget _headerBar() {
    bool isMy = selectedItem?.userId == _auth.currentUser?.userId;
    return Positioned(
        top: 40,
        left: 10,
        right: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BACK BUTTON
            TextButton(
                onPressed: () {
                  controller.resetValues();
                  if(isMy) {
                    Get.back();
                  }
                },
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

            AnimatedContainer(
            duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: buy ? const EdgeInsets.all(10) : null,
          width: buy ? 100 : null,
          child: buy ?
          WalletButton(onTap: (){}, val: _auth.currentUser?.wallet,) :
          UserAvatar(
            selectedItem?.userDetails?.profilePic != null && selectedItem!.userDetails!.profilePic!.isNotEmpty ?
            "${Constants.IMAGE_URL}${selectedItem!.userDetails!.profilePic!}" :
            Constants.dummyImage,
            selectedItem!.userId.toString(),
            padding: const EdgeInsets.all(5.0),
            badgeContent: null,
            radius: 25,
          )
        ),
      ],
    )
    );
  }

  Widget _buyButton() {
    bool isMy = selectedItem?.userId == _auth.currentUser?.userId;
    return Positioned(
        bottom: 10,
        left: 10,
        right: 10,
        child: _loading || _buying ?
        const SizedBox(
          height: 90,
          child: Loader(),
        ) :
        TextButton(
          onPressed: () => isMy ? controller.editItem() : controller.buyItem(true),
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
              Text(isMy ? "Edit This" : "Buy This"),
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.secondaryColor,
                    shape: BoxShape.circle
                ),
                padding: const EdgeInsets.all(15),
                child: Icon(isMy ? AntDesign.edit : AntDesign.arrowright),
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
              Color paletteColor = palette?.dominantColor?.color ?? AppColors.secondaryColor;
              Color paletteSkin = palette?.mutedColor?.color ?? AppColors.secondaryColor;
              Color textColor = (paletteColor.computeLuminance() >= 0.5)? Colors.black : Colors.white;
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
                                      selectedItem?.type ?? "",
                                      color: AppColors.lightGrey, weight: FontWeight.w400, size: 12),
                                  // TextWidget(
                                  //     "${_auth.currentUser?.wallet}",
                                  //     color: AppColors.lightGrey, weight: FontWeight.w400, size: 12),
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
                                          style: TextStyle(fontSize: Get.textScaleFactor * 28, fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "  Dollar",
                                          style: TextStyle(fontSize: Get.textScaleFactor * 10),
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
                          color: paletteSkin.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      height: Get.height * 0.16,
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextWidget("Description",
                              color: textColor,
                              weight: FontWeight.w400, size: Get.textScaleFactor * 12, align: TextAlign.center),
                          const Divider(height: 30),

                          Flexible(child: Text(
                            selectedItem?.description ?? "",
                            style: TextStyle(
                                color: textColor,
                                fontSize: Get.textScaleFactor * 16
                            ),
                            // color: textColor,
                            // weight: FontWeight.w400,
                            //   size: 16
                          )),

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

  Widget _title() {
    Color paletteColor = palette?.dominantColor?.color ?? AppColors.secondaryColor;
    Color textColor = (paletteColor.computeLuminance() >= 0.5)? Colors.black : Colors.white;
    return Positioned(
      top: 100,
        right: 20,
        child: Text(
          (selectedItem?.title ?? "").replaceAll(" ", "\n"),
          textAlign: TextAlign.end,
          style: TextStyle(
              color: textColor,
              fontSize: Get.textScaleFactor * 50,
            fontWeight: FontWeight.w600
          ),
        )
    );
  }

  Widget _audioCard(int index) {
    if(!_loading) {
      return AudioItem(listing: selectedItem!);
    }
    return Container(
        decoration: const BoxDecoration(
          color: AppColors.secondaryColor,
        ),
        alignment: Alignment.center,
        child: const Icon(Entypo.note, color: AppColors.primaryColor, size: 80,)
    );

    // return AspectRatio(
    //   aspectRatio: 0.5,
    //   child: BetterPlayerListVideoPlayer(
    //     BetterPlayerDataSource(
    //       BetterPlayerDataSourceType.network,
    //       // "${Constants.FEEDS_URL}${_listing.elementAt(Get.arguments)?.mainFile}",
    //       "${Constants.LISTING_URL}${ selectedItem?.files?.elementAt(index).filePath ?? _listing.elementAt(Get.arguments)?.mainFile}",
    //       notificationConfiguration: BetterPlayerNotificationConfiguration(
    //         showNotification: false,
    //         title: _listing.elementAt(Get.arguments)?.title ?? "",
    //         author: "Test",
    //       ),
    //       bufferingConfiguration: const BetterPlayerBufferingConfiguration(
    //           minBufferMs: 2000,
    //           maxBufferMs: 10000,
    //           bufferForPlaybackMs: 1000,
    //           bufferForPlaybackAfterRebufferMs: 2000),
    //     ),
    //     configuration: BetterPlayerConfiguration(
    //         autoDispose: false,
    //         looping: true,
    //         fit: BoxFit.cover,
    //         autoPlay: true,
    //         aspectRatio: 0.5,
    //         eventListener: (p0) {
    //           if(p0.betterPlayerEventType == BetterPlayerEventType.setVolume) {
    //             controller.betterCtrl;
    //           }
    //         },
    //         // handleLifecycle: true,
    //         controlsConfiguration: const BetterPlayerControlsConfiguration(
    //             enableFullscreen: false,
    //             showControlsOnInitialize: true,
    //             enablePlaybackSpeed: false,
    //             enableProgressBar: false,
    //             enableOverflowMenu: false,
    //             enableProgressText: false,
    //             enablePip: false,
    //             enableSkips: false,
    //             // loadingWidget: Loader(),
    //             controlBarColor: Colors.transparent,
    //             playIcon: FontAwesome5Solid.play_circle,
    //             pauseIcon: FontAwesome5Solid.pause_circle,
    //             muteIcon: FontAwesome5Solid.volume_up,
    //             unMuteIcon: FontAwesome5Solid.volume_mute,
    //             enablePlayPause: false
    //         )
    //     ),
    //     //key: Key(videoListData.hashCode.toString()),
    //     playFraction: 0.8,
    //     betterPlayerListVideoPlayerController: controller.betterCtrl,
    //   ),
    // );
  }
}
