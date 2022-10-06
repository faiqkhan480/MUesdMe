import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings/firebase_binding.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/di_setup.dart' as di;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.initServices(); /// AWAIT SERVICES INITIALIZATION.();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MUsedMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.black,
            fontSize: 20,
            fontFamily: 'Larsseit',
            fontWeight: FontWeight.w500,
          )
        ),
        fontFamily: 'Larsseit'
      ),
      // initialRoute: AppRoutes.LOGIN,
      initialRoute: getInitialRoute(),
      getPages: AppPages.list,
      initialBinding: FirebaseBinding(),
    );
  }

  String getInitialRoute() {
    final GetStorage box = GetStorage();
    if(box.read("token") != null) {
      return AppRoutes.ROOT;
    }
    else {
      return AppRoutes.LOGIN;
    }
  }
}