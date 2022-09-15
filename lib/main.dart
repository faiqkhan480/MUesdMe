import 'package:flutter/material.dart';

import 'navigation/bottom_navigation.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musedme',
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
      home: const LoginScreen(),
      // home: const BottomNavigation(),
    );
  }
}
