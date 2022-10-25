import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/api_res.dart';
import '../models/listing.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class MarketController extends GetxController {
  Rx<Listing?> selectedItem = Rxn<Listing?>();

  RxBool buy = false.obs;
  RxBool loading = true.obs;
  RxBool fetching = false.obs;
  RxInt currIndex = 0.obs;
  Rx<BoxFit> boxFit = BoxFit.cover.obs;
  Rx<Alignment> alignment = const Alignment(0.6, 0).obs;
  Rx<BorderRadius> borderRadius = BorderRadius.circular(30).obs;

  BetterPlayerListVideoPlayerController betterCtrl = BetterPlayerListVideoPlayerController();

  Rx<PaletteGenerator?> palette = Rxn<PaletteGenerator?>();

  Rx<Listing?> uploadItem = Rxn<Listing?>();
  RxList<Listing?> listing = List<Listing?>.empty(growable: true).obs;

  RxDouble height = Get.height.obs;
  RxDouble width = Get.width.obs;

  final ApiService _service = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    betterCtrl = BetterPlayerListVideoPlayerController();
    betterCtrl.setVolume(0);
    getAllListing();
  }

  // GET ALL LISTING ITEMS
  Future<void> getAllListing() async {
    List<Listing?> res = await _service.fetchListing();
    if(res.isNotEmpty) {
      if(listing.isEmpty) {
        listing.addAll(res);
      }
      else {
        listing.clear();
        listing.addAll(res);
      }
    }
    loading.value = false;
  }

  void setItem(Listing item, index) async {
    debugPrint("::::::::::::::::");
    selectedItem = item.obs;
    if(selectedItem.value?.category == "Images" || selectedItem.value?.category == "Image") {
      await updatePaletteGenerator();
    }
    Get.toNamed(AppRoutes.ITEM, arguments: index);
    getItemDetail();
  }

  Future<void> getItemDetail() async {
    loading.value = true;
    Listing? res = await _service.fetchItemDetails(selectedItem.value!.itemId!.toString());
    if(res != null) {
      selectedItem = res.obs;
    }
    loading.value = false;
  }

  void buyItem() {
    buy.value = !buy();
    // boxFit.value = buy() ? BoxFit.none : BoxFit.cover;
    height.value = buy() ? 500 : Get.height;
    width.value = buy() ? Get.width : Get.width;
    // alignment.value = buy() ? Alignment.topCenter : const Alignment(0.6, 0);
    borderRadius.value = buy() ? BorderRadius.circular(0) : BorderRadius.circular(30);
  }

  void resetValues() {
    if(!buy()) {
      Get.back();
    }
    buy.value = false;
    // boxFit.value = buy() ? BoxFit.none : BoxFit.cover;
    height.value = Get.height;
    borderRadius.value = buy() ? BorderRadius.circular(0) : BorderRadius.circular(30);
  }

  Future updatePaletteGenerator([String? path, int? index]) async {
    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      // Image.network(nft.value).image,
      Image.network("${Constants.LISTING_URL}${path ?? selectedItem.value?.mainFile}").image,
    );

    palette = paletteGenerator.obs;
    currIndex.value = index ?? currIndex.value;
    // palette.refresh();
    // return paletteGenerator;
  }

  Future<void> uploadFile(String category) async {
    if(!fetching()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,
          type: category == "Image" ? FileType.image : category == "Video" ? FileType.video : FileType.audio,
          // allowedExtensions: ['jpg', 'jpeg', 'png', 'mp3', 'mp4', 'gif']
      );

      if (result != null) {
        fetching.value = true;
        List<String> files = result.paths.map((path) => path ?? "").toList();

        // debugPrint("RESULT ::::::::::$files");

        Listing? res = await _service.uploadListingFile(files);
        if(res != null) {
          uploadItem = res.obs;
          Get.toNamed(AppRoutes.ITEMUPLOAD, arguments: category);
          //   res.copyWith(
          //     userId: _authService.currentUser!.userId!,
          //     type: ,
          //   );
        }
      }
      fetching.value = false;
    }
  }

}