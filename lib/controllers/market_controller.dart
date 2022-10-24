import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/api_res.dart';
import '../models/listing.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class MarketController extends GetxController {
  RxString nft = "".obs;

  RxBool buy = false.obs;
  RxBool loading = false.obs;
  Rx<BoxFit> boxFit = BoxFit.cover.obs;
  Rx<Alignment> alignment = const Alignment(0.6, 0).obs;
  Rx<BorderRadius> borderRadius = BorderRadius.circular(30).obs;

  Rx<PaletteGenerator?> palette = Rxn<PaletteGenerator?>();

  Rx<Listing?> listing = Rxn<Listing?>();

  RxDouble height = Get.height.obs;
  RxDouble width = Get.width.obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

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

  Future updatePaletteGenerator() async {
    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(nft.value).image,
    );

    palette = paletteGenerator.obs;
    // return paletteGenerator;
  }

  Future<void> uploadFile() async {
    if(!loading()) {
      loading.value = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'mp3', 'mp4', 'gif']);

      if (result != null) {
        List<String> files = result.paths.map((path) => path ?? "").toList();

        // debugPrint("RESULT ::::::::::$files");

        Listing? res = await _service.uploadListingFile(files);
        if(res != null) {
          listing = res.obs;
          Get.toNamed(AppRoutes.ITEMUPLOAD);
          //   res.copyWith(
          //     userId: _authService.currentUser!.userId!,
          //     type: ,
          //   );
        }
      }
      loading.value = false;
    }
  }

  Future<void> _uploadListing() async {

  }
}