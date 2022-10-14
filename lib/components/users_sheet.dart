import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/agora_controller.dart';
import '../controllers/feed_controller.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';
import 'search_field.dart';

class UsersSheet extends StatefulWidget {
  const UsersSheet({Key? key}) : super(key: key);

  @override
  State<UsersSheet> createState() => _UsersSheetState();
}

class _UsersSheetState extends State<UsersSheet> {
  final List<int> _selections = [];

  FeedController get controller => Get.find<FeedController>();
  AgoraController get _agora => Get.find<AgoraController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
        ),

        Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CLOSE BUTTON
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                width: 90,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.close, color: Colors.white, size: 15,),
                    SizedBox(width: 5,),
                    TextWidget("Close", color: Colors.white, weight: FontWeight.normal, size: 12),
                  ],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: 30,
              height: 3,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.white
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // HEADER
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.shadowColor,
                              // spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    padding: const EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(Assets.iconsAdd, color: AppColors.primaryColor),
                            const SizedBox(width: 5,),
                            const TextWidget("Invite People to Join live", size: 16, color: AppColors.primaryColor, weight: FontWeight.normal),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        const SearchField(placeHolder: "Write name of people you want to invite...")
                      ],
                    ),
                  ),

                  const SizedBox(height:  20,),

                  // USERS
                  Flexible(child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                        // mainAxisSpacing:5
                    ),
                    itemCount: controller.users.length,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 50),
                    itemBuilder: (context, index) => Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => setState(() => (_selections.contains(index) ? _selections.remove(index) : _selections.add(index))),
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            StreamBuilder(
                                stream: _agora.checkStatus(controller.users.elementAt(index)!.userId.toString()),
                                builder: (context, snapshot) => Badge(
                                  badgeColor: AppColors.lightGrey,
                                  position: BadgePosition.topEnd(top: -1, end: 4),
                                  elevation: 0,
                                  padding: _selections.contains(index) ? EdgeInsets.zero : const EdgeInsets.all(5.0),
                                  badgeContent: _selections.contains(index) ? SvgPicture.asset(Assets.iconsSelection) : null,
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                        controller.users.elementAt(index)?.profilePic != null && controller.users.elementAt(index)!.profilePic!.isNotEmpty ?
                                        "${Constants.IMAGE_URL}${controller.users.elementAt(index)?.profilePic}" :
                                        Constants.dummyImage,
                                      )),
                                )
                            ),
                            const SizedBox(height: 5,),
                            TextWidget(controller.users.elementAt(index)?.userName ?? "")
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),

        InkWell(
          onTap: _handleSubmit,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
            decoration: const BoxDecoration(
                color: AppColors.successColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor,
                      // spreadRadius: 3,
                      blurRadius: 5
                  )
                ]
            ),
            child: SizedBox(
              height: 54,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.iconsLive, color: Colors.white),
                  const SizedBox(width: 5,),
                  const TextWidget("Send Invitation", color: Colors.white, weight: FontWeight.normal),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _handleSubmit() {}
}
