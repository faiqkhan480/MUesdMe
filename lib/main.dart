import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/di_setup.dart' as di;

void main() async {
  await di.initServices(); /// AWAIT SERVICES INITIALIZATION.();
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
      getPages: AppPages.list
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