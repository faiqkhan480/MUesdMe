import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../components/header.dart';
import '../../controllers/market_controller.dart';
import '../../models/listing.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/glass_morphism.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/thumbnail_widget.dart';
import 'orders_screen.dart';

class MarketScreen extends GetView<MarketController>  {
  const MarketScreen({Key? key}) : super(key: key);

  bool get _fetching => controller.fetching();
  bool get _loading => controller.loading();
  List<Listing?> get _listing => controller.listing;

  AuthService get _authService => Get.find<AuthService>();
  TabController get _tabX  => controller.tabController;
  // MarketController get _authService => Get.find<MarketController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(
                title: "Market",
                isProfile: true,
                hideButton: false,
                showButtonIcon: false,
                buttonText: "My Orders",
                action: () => Get.to(const OrdersScreen()),
              ),

              // TAB BAR
              Padding(
                padding: const EdgeInsets.only(top: 10),
                // padding: EdgeInsets.only(top: toolbarHeight),
                child: SizedBox(
                  height: 50,
                  child: TabBar(
                    controller: _tabX,
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: Colors.black,
                      isScrollable: false,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                      indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.5, color: AppColors.primaryColor),
                          insets: EdgeInsets.symmetric(horizontal: 20.0)),
                      tabs: List.generate(controller.myTabs.length, (index) => Tab(
                        text: controller.myTabs.elementAt(index),
                      ))
                  ),
                ),
              ),

              // TAB VIEWS
              Flexible(
                child: TabBarView(
                  controller: _tabX,
                  children: [
                    _items(_listing.where((f) => f?.userId != _authService.currentUser?.userId).toList().obs, 0),
                    _items(_listing.where((f) => f?.userId == _authService.currentUser?.userId).toList().obs, 1),
                  ],
                ),
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
        ],
        activeIcon: Icons.close,
        icon: Icons.add,
      ),
    );
  }

  Widget _items(RxList<Listing?> data, int tab) {
    return RefreshIndicator(
      onRefresh: controller.getAllListing,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: data.length,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemBuilder: (context, index) => InkWell(
            onTap: () => onTap(data.elementAt(index)!, _listing.indexOf(data.elementAt(index))),
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: "pop$tab$index",
                      child: data.elementAt(index)?.category == "Video" ?
                      ThumbnailWidget("${Constants.LISTING_URL}${data.elementAt(index)?.mainFile}") :
                      data.elementAt(index)?.category == "Music" ?
                      audioCard() :
                      imageCard("${Constants.LISTING_URL}${data.elementAt(index)?.mainFile}"),
                    )
                ),

                if(data.elementAt(index)?.category == "Video")
                  const Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(Feather.film, color: Colors.white)),

                if(data.elementAt(index)?.category == "Music")
                  const Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(Feather.music, color: Colors.white)),

                Positioned.fill(
                    bottom: 36,
                    left: 10,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextWidget("${data.elementAt(index)?.title}",
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
                        TextWidget("${data.elementAt(index)?.price}\$", color: Colors.white, size: 15, weight: FontWeight.w600),
                      ],
                    ),
                  ),),
              ],
            ),
          )
      ),
    );
  }

  Widget audioCard() {
    return Container(
        color: AppColors.secondaryColor,
        alignment: Alignment.center,
        child: const Icon(Entypo.note, color: AppColors.primaryColor, size: 80,)
    );
  }

  Widget imageCard(String path) {
    return Image.network(
      path,
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
      fit: BoxFit.cover, height: double.infinity, width: double.infinity,);
  }

  void onTap(Listing item, int index) {
   controller.setItem(item, index);
  }
}
