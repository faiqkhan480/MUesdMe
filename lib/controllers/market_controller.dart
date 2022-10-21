import 'package:get/get.dart';

import '../routes/app_routes.dart';

class MarketController extends GetxController {
  RxString nft = "".obs;

  void setItem(String item ) {
    nft.value = item;
    Get.toNamed(AppRoutes.ITEM);
  }

  void buyItem() {

  }
}