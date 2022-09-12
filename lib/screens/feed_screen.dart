import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/components/header.dart';
import 'package:musedme/generated/assets.dart';
import 'package:musedme/utils/app_colors.dart';

import '../components/feed_card.dart';
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
          const Header(title: "Live Feed", showLives: true),
          const SizedBox(height: 20,),
          Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) => const FeedCard(),
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemCount: 4
              )
          ),
        ],
      ),
    );
  }
}
