import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/components/header.dart';
import 'package:musedme/screens/search_screen.dart';
import 'package:musedme/utils/assets.dart';
import 'package:musedme/utils/app_colors.dart';

import '../components/feed_card.dart';
import '../navigation/bottom_navigation.dart';
import '../utils/constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: "Live Feed", showLives: true, action: () => null, handleSearch: handleNavigation),
          const SizedBox(height: 20,),
          Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) => FeedCard(isVideo: index != 0),
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemCount: 4
              )
          ),
        ],
      ),
    );
  }

  handleNavigation() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => const SearchScreen()));
  }
}
