import 'package:get/get.dart';

import '../models/auths/user_model.dart';
import '../services/auth_service.dart';
import 'agora_controller.dart';

class CallController extends GetxController {
  RxBool loading = true.obs;

  Rx<User> user = User().obs;

  final AuthService _authService = Get.find<AuthService>();

  final AgoraController _agora = Get.find<AgoraController>();

  var args = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(args != null) {
      user.value = args;
      loading.value = false;
    }
  }

  void endCall() {
    Get.back();
  }
}