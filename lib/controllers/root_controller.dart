import 'package:get/get.dart';

class RootController extends GetxController {
  Rx<int> currIndex = 0.obs;


  // CHANGE BOTTOM PAGE
  void handleTab(int index) {
      currIndex.value = index;
  }
}