import 'package:get_it/get_it.dart';

import '../services/api_service.dart';
import '../services/auth_service.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //Auth service for authentication operations
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
}