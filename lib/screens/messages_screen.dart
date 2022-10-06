import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popover/popover.dart';

import '../components/search_field.dart';
import '../screens/chat_screen.dart';
import '../widgets/text_widget.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 5),
          child: TextButton(
              onPressed: () => (Navigator.canPop(context)) ? Navigator.pop(context) : null,
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
              ),
              child: const Icon(CupertinoIcons.back, color: AppColors.secondaryColor,)
          ),
        ),
        title: const SearchField(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       TextButton(
            //           onPressed: () => null,
            //           style: TextButton.styleFrom(
            //               backgroundColor: Colors.white,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(8),
            //                   side: BorderSide(color: AppColors.lightGrey.withOpacity(0.2))
            //               ),
            //               padding: const EdgeInsets.symmetric(vertical: 18),
            //               textStyle: const TextStyle(fontSize: 12, fontFamily: Constants.fontFamily)
            //           ),
            //           child: const Icon(CupertinoIcons.back, color: AppColors.secondaryColor,)
            //       ),
            //
            //       const SizedBox(width: 20,),
            //
            //       const Expanded(child: SearchField()),
            //     ],
            //   ),
            // ),

            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: TextWidget("Messages", size: 28, weight: FontWeight.bold,),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextWidget("You have 2 new messages", color: AppColors.lightGrey, weight: FontWeight.normal,),
            ),

            Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 20, bottom: 0),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color: index == 1 ? AppColors.progressColor : index == 5 ? AppColors.successColor : Colors.white,
                            width: 4
                          )
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            onTap: () => handleNavigation("Julian Dasilva"),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            leading: Badge(
                              badgeColor: AppColors.successColor,
                              position: BadgePosition.topEnd(top: -1, end: 4),
                              elevation: 0,
                              showBadge: index == 0 || index == 1 || index == 4,
                              borderSide: const BorderSide(color: Colors.white, width: .7),
                              child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  backgroundImage: NetworkImage(Constants.albumArt)),
                            ),
                            title: const TextWidget("Julian Dasilva", weight: FontWeight.w800),
                            subtitle: const TextWidget("Hi Julian! See you after work?", size: 12, weight: FontWeight.w500, color: AppColors.lightGrey),
                            trailing: GestureDetector(
                                onTap: () {
                                  // showPopover(
                                  //   context: context,
                                  //   transitionDuration: const Duration(milliseconds: 150),
                                  //   bodyBuilder: (context) => const ListItems(),
                                  //   onPop: () => print('Popover was popped!'),
                                  //   direction: PopoverDirection.top,
                                  //   width: 200,
                                  //   height: 400,
                                  //   arrowHeight: 15,
                                  //   arrowWidth: 30,
                                  // );
                                },
                                child: SvgPicture.asset(Assets.iconsAdd)
                            )
                          ),
                          if(index == 5)
                            const Divider(color: AppColors.grayScale, thickness: 1, height: 1),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(color: AppColors.grayScale, thickness: 1, height: 1),
                    itemCount: 6
                )
            ),
          ],
        ),
      ),
    );
  }

  handleNavigation(String title) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => const ChatScreen(),));
  }

  void handleClick() {
    showPopover(
      context: context,
      transitionDuration: const Duration(milliseconds: 150),
      bodyBuilder: (context) => const ListItems(),
      onPop: () => print('Popover was popped!'),
      direction: PopoverDirection.top,
      width: 200,
      height: 400,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            InkWell(
              onTap: () {
              },
              child: Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry A')),
              ),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[200],
              child: const Center(child: Text('Entry B')),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[300],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ),
      ),
    );
  }
}