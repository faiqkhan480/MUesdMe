import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'agora_controller.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ]
);

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final AgoraController _agora = Get.find<AgoraController>();

  handleLogout () async {
    await _authService.clearUser();
    // Going back all route/pages until LOGIN page you can even pass a predicate/ condition to pop until that condition passes
    _agora.logout();
    Get.offAllNamed(AppRoutes.LOGIN);

    // GOOGLE SIGN OUT
    _googleSignIn.disconnect();
  }
}