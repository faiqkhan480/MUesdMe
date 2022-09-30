import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/screens/edit_profile_screen.dart';
import 'package:musedme/utils/constants.dart';

import '../components/custom_header.dart';
import '../components/feed_card.dart';
import '../components/header.dart';
import '../components/info_card.dart';
import '../models/auths/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/assets.dart';
import '../utils/app_colors.dart';
import '../utils/di_setup.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  final User? profile;
  const ProfileScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool loader = true;

  final AuthService _authService = getIt<AuthService>();
  final ApiService _apiService = getIt<ApiService>();

  List<String> tabs = [
    "My Feed",
    "Images",
    "Videos"
  ];

  double toolbarHeight = 35;

  ScrollController controller = ScrollController();

  void handleClick() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => EditProfileScreen(user: user),));
  }

  Future<void> getUser() async {
    User? res = await _authService.getUser(uid: widget.profile?.userId);
      setState(() {
        user = res;
        loader = false;
      });
  }

  Future<void> handleFollow() async {
    setState(() => loader = true);
    User? res = await _apiService.followReq((user?.userId ?? "").toString(), user?.follow ?? 0);
      setState(() {
        if(res != null) {
          user?.follow = user?.follow == 0 ? 1 : 0;
          user?.followers = res.followers;
        }
        loader = false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if(controller.position.pixels > 540) {
        setState(() {
          toolbarHeight = 120;
        });
      } else if(controller.position.pixels < 620) {
        setState(() {
          toolbarHeight = 35;
        });
      }
    });
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body:
        Stack(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              // color: Colors.red,
              child: (!loader || user != null) ?
              Align(
                alignment: Alignment.topCenter,
                child: Image.network(Constants.coverImage,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ) : null,
            ),
            (loader && user == null) ?
            Center(child: Lottie.asset(Assets.loader)):
            RefreshIndicator(
              onRefresh: getUser,
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  // USER INFO
                  SliverAppBar(
                    pinned: false,
                    expandedHeight: 300.0,
                    automaticallyImplyLeading: false,
                    // flexibleSpace: Image.network(Constants.coverImage,
                    //   height: 400,
                    //   fit: BoxFit.cover,
                    // ),
                    toolbarHeight: 300,
                    backgroundColor: Colors.transparent,
                    // excludeHeaderSemantics: true,
                    bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 180),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        child: InfoCard(
                          user: user,
                          button: (widget.profile != null) ?
                          ButtonWidget(
                            text: user?.follow == 0 ? "Follow" : "Un Follow",
                            onPressed: handleFollow,
                            bgColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            loader: loader,
                          ) : null,
                        ),
                      ),
                    ),
                  ),

                  // TAB BAR
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 50,
                    // collapsedHeight: 0,
                    toolbarHeight: toolbarHeight,
                    bottom: PreferredSize(
                        preferredSize: const Size(double.infinity, 0),
                        child: Row(
                          children: [
                            TabBar(
                                labelColor: AppColors.primaryColor,
                                unselectedLabelColor: Colors.black,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                                indicator: const UnderlineTabIndicator(
                                    borderSide: BorderSide(width: 2.5, color: AppColors.primaryColor),
                                    insets: EdgeInsets.symmetric(horizontal: 35.0)),
                                tabs: List.generate(tabs.length, (index) => Tab(
                                  text: tabs.elementAt(index),
                                ))
                            ),
                          ],
                        )
                    ),
                  ),

                  // FEEDS LIST
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: const FeedCard(horizontalSpace: 10, index: 0),
                      );
                    },
                      childCount: 4,
                    ),
                  ),
                ],
              ),
            ),

            if(widget.profile != null)
              const SizedBox(
                  height: 100,
                  child: CustomHeader(
                      title: "Profile",
                      buttonColor: AppColors.primaryColor,
                      showBottom: false,
                      showSave: false
                  ))
            else
              Header(
              title: "Profile",
              isProfile: true,
              showShadow: false,
              action: handleClick,
              height: 108,
            ),
          ],
        ),
      ),
    );
  }
}
