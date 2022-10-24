import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../routes/app_routes.dart';

class MarketController extends GetxController {
  RxString nft = "".obs;

  RxBool buy = false.obs;
  Rx<BoxFit> boxFit = BoxFit.cover.obs;
  Rx<Alignment> alignment = const Alignment(0.6, 0).obs;
  Rx<BorderRadius> borderRadius = BorderRadius.circular(30).obs;

  Rx<PaletteGenerator?> palette = Rxn<PaletteGenerator?>();

  RxDouble height = Get.height.obs;
  RxDouble width = Get.width.obs;

  void setItem(String item, index) async {
    nft.value = item;
    await updatePaletteGenerator();
    Get.toNamed(AppRoutes.ITEM, arguments: index);
  }

  void buyItem() {
    buy.value = !buy();
    // boxFit.value = buy() ? BoxFit.none : BoxFit.cover;
    height.value = buy() ? 500 : Get.height;
    width.value = buy() ? Get.width : Get.width;
    // alignment.value = buy() ? Alignment.topCenter : const Alignment(0.6, 0);
    borderRadius.value = buy() ? BorderRadius.circular(0) : BorderRadius.circular(30);
  }

  resetValues() {
    if(!buy()) {
      Get.back();
    }
    buy.value = false;
    // boxFit.value = buy() ? BoxFit.none : BoxFit.cover;
    height.value = Get.height;
    borderRadius.value = buy() ? BorderRadius.circular(0) : BorderRadius.circular(30);
  }

  // Future onWillPop(){
  //   resetValues();
  //   // return true;
  //   // return buy() ? false : true;
  // }

  Future updatePaletteGenerator() async {
    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(nft.value).image,
    );

    palette = paletteGenerator.obs;
    debugPrint("::::::::::::$paletteGenerator");
    // return paletteGenerator;
  }
}