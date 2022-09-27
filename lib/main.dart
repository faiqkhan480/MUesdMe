import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'navigation/bottom_navigation.dart';
import 'screens/auth/login_screen.dart';
import 'utils/di_setup.dart' as di;

void main() async {
  await GetStorage.init();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GetStorage box = GetStorage();
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
      home: box.read("token") != null ? const BottomNavigation() : const LoginScreen(),
      // home: const BottomNavigation(),
    );
  }
}
