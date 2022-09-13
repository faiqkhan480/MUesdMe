import 'package:flutter/material.dart';
import 'package:musedme/screens/edit_profile_screen.dart';
import 'package:musedme/screens/feed_screen.dart';

import 'navigation/bottom_navigation.dart';

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
      // home: const EditProfileScreen(),
      home: const BottomNavigation(),
    );
  }
}
