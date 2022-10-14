import 'package:better_player/better_player.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  RxBool loading = true.obs;
  BetterPlayerListVideoPlayerController betterCtrl= BetterPlayerListVideoPlayerController();
  BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(autoPlay: true);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    // betterCtrl = BetterPlayerListVideoPlayerController() as BetterPlayerConfiguration;
    // betterPlayerConfiguration = const BetterPlayerConfiguration(autoPlay: true) as BetterPlayerListVideoPlayerController;

    loading.value = false;
  }
}