import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/api_service.dart';
import '../services/auth_service.dart';


Future<void> initServices() async {
  await GetStorage.init();

  //Auth service for authentication operations
  await Get.putAsync(() => AuthService().init());
  // Get.lazyPut(() => AuthService());
  // Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<ApiService>(ApiService(), permanent: true);
}