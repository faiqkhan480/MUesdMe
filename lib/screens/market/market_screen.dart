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

final List<String> nfts = [
  "https://i.pinimg.com/564x/79/6c/29/796c2975ae64e163566bade45f579e9c.jpg",
  "https://i.pinimg.com/564x/5c/95/59/5c955918cb5429b97a101b94b97c3905.jpg",
  "https://i.pinimg.com/564x/76/b5/89/76b58934eddf4792be7ce37259d62bcb.jpg",
  "https://i.pinimg.com/236x/43/81/14/4381145cc8d8fec1f113aafb72877afe.jpg",
  "https://i.pinimg.com/564x/5e/59/8e/5e598e9a2181b3d81599f9e5081f4067.jpg",
  "https://i.pinimg.com/564x/06/c0/56/06c056ebc748593b2d185580d87e9f14.jpg",
  "https://i.pinimg.com/564x/6b/17/bb/6b17bbb0ea4edb7c9a8f13617e8e6f0f.jpg",
  "https://i.pinimg.com/564x/04/a8/18/04a818741f053f762f8866be83b7ffb6.jpg",
  "https://i.pinimg.com/564x/0f/ef/24/0fef2461977f02f2e931da94bc486479.jpg",
  "https://i.pinimg.com/564x/ab/55/83/ab558328dc7662da778c8370ff60f0f7.jpg",
  "https://i.pinimg.com/564x/6a/c7/2f/6ac72fb532e6b98d01eb8f5e64648905.jpg",
  "https://i.pinimg.com/564x/2e/59/c1/2e59c1876dd6b6d5852be2d3e99a65fb.jpg",
  "https://i.pinimg.com/564x/e5/88/de/e588de98a37d016b42c117caac0a00ef.jpg",
  "https://i.pinimg.com/564x/6c/48/8e/6c488e35f38e165f2225253d02d15385.jpg",
  "https://i.pinimg.com/564x/42/51/de/4251de661abe34271344e8bf674b0963.jpg",
  "https://i.pinimg.com/564x/62/cf/f2/62cff255396fd582a5ef398c95bbb4df.jpg",
  "https://i.pinimg.com/564x/79/f3/ec/79f3ec1cb93a6799aabe9b5d23abd282.jpg",
  "https://i.pinimg.com/564x/aa/d6/4d/aad64de8eaf1f176b9a9b63df8710de5.jpg",
  "https://i.pinimg.com/564x/81/08/0a/81080ab220d59ae816de056a6d27bc42.jpg",
  "https://i.pinimg.com/564x/01/55/9a/01559aab5e56a731157240f6458ea267.jpg",
];

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
                                            color: AppColors.primaryColor,
                                              // borderRadius: BorderRadius.circular(20),
                                              // border: Border.all(color: AppColors.secondaryColor)
                                          ),
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(Assets.logoSvg, fit: BoxFit.cover,),),
                                          // child: Icon(Feather.image, color: AppColors.secondaryColor, size: 40,)),
                                      fit: BoxFit.cover, height: double.infinity, width: double.infinity,),
                                  )
                              ),

                              Positioned(
                                bottom: 36,
                                left: 10,
                                child: TextWidget("${_listing.elementAt(index)?.title}", color: Colors.white, size: 22),),
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
                                      TextWidget("${_listing.elementAt(index)?.price}\$", color: Colors.white, size: 16, weight: FontWeight.w600),
                                    ],
                                  ),
                                ),),

                              // const TextWidget("Hype Beast", color: Colors.white, size: 22),
                              // const SizedBox(height: 5,),

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

          if(_fetching || _loading)
            const Loader()
        ],
      )),

      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
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
   controller.setItem(nfts.elementAt(index), index);
  }
}
