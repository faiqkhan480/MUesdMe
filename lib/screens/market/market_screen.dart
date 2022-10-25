import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:musedme/utils/constants.dart';

import '../../components/header.dart';
import '../../controllers/market_controller.dart';
import '../../models/listing.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import '../../widgets/glass_morphism.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';

class MarketScreen extends GetView<MarketController> {
  const MarketScreen({Key? key}) : super(key: key);

  bool get _fetching => controller.fetching();
  bool get _loading => controller.loading();
  List<Listing?> get _listing => controller.listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Header(
                title: "Market",
                isProfile: true,
                hideButton: true,
              ),

              Flexible(
                  child: RefreshIndicator(
                    onRefresh: controller.getAllListing,
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _listing.length,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => onTap(index),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Hero(
                                    tag: "pop$index",
                                    child: Image.network(
                                      "${Constants.LISTING_URL}${_listing.elementAt(index)?.mainFile}",
                                      loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
                                      errorBuilder: (context, error, stackTrace) => Container(
                                          decoration: const BoxDecoration(
                                            color: AppColors.secondaryColor,
                                              // borderRadius: BorderRadius.circular(20),
                                              // border: Border.all(color: AppColors.secondaryColor)
                                          ),
                                          alignment: Alignment.center,
                                          // child: SvgPicture.asset(Assets.iconsNoFeeds, fit: BoxFit.cover,),),
                                          child: const Icon(Feather.image, color: Colors.white, size: 100,)),
                                      fit: BoxFit.cover, height: double.infinity, width: double.infinity,),
                                  )
                              ),

                              Positioned.fill(
                                bottom: 36,
                                left: 10,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: TextWidget("${_listing.elementAt(index)?.title}",
                                      color: Colors.white, size: 20),
                                )
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: GlassMorphism(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  shape: BoxShape.rectangle,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const TextWidget("Price ", color: AppColors.grayScale, weight: FontWeight.w400, size: 12),
                                      TextWidget("${_listing.elementAt(index)?.price}\$", color: Colors.white, size: 15, weight: FontWeight.w600),
                                    ],
                                  ),
                                ),),
                            ],
                          ),
                        )
                    ),
                  )
              ),
            ],
          ),

          if(_fetching)
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4)
              ),
            ),

          if(_fetching || (_loading && _listing.isEmpty))
            const Loader()
        ],
      )),

      floatingActionButton: SpeedDial(
        animatedIconTheme: const IconThemeData(size: 22.0),
        visible: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
              child: const Icon(Feather.image),
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              label: 'Upload Image',
              // labelStyle: TextTheme(fontSize: 18.0),
              onTap: () => controller.uploadFile("Image")
          ),
          SpeedDialChild(
            child: const Icon(Feather.film),
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.white,
            label: 'Upload Video File',
            // labelStyle: TextTheme(fontSize: 18.0),
            onTap: () => controller.uploadFile("Video"),
          ),
          SpeedDialChild(
            child: const Icon(Feather.headphones),
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.white,
            label: 'Upload audio file',
            // labelStyle: TextTheme(fontSize: 18.0),
            onTap: () => controller.uploadFile("Music"),
          ),
        ],
        activeIcon: Icons.close,
        icon: Icons.add,
      ),
    );
  }

  void onTap(int index ) {
   controller.setItem(_listing.elementAt(index)!, index);
  }
}
