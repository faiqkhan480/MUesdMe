import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../components/search_field.dart';
import '../controllers/search_controller.dart';
import '../models/auths/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';
import '../widgets/shadowed_box.dart';
import '../widgets/text_widget.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({Key? key}) : super(key: key);

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  SearchController get _controller => Get.find<SearchController>();

  List<User?> get _users => _controller.users;
  bool get loader => _controller.loading();
  bool? get searchResult => _controller.searchResult();

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
        title: SearchField(onSubmit: _controller.getUsers),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextWidget(
                (!loader && _users.isEmpty && searchResult == true) ?
                "No user found!" :
                "Search Result of talented creators",
                size: 18, color: AppColors.lightGrey, align: TextAlign.center),

            if(loader)
              const Loader()
            else if(!loader && _users.isEmpty && searchResult == true)...[
              SvgPicture.asset(Assets.searchUsers)
            ]
            else if(!loader && _users.isEmpty)
                SvgPicture.asset(Assets.emptySearch)
            else
              Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.9,
                      // childAspectRatio: 0.9,
                    ),
                  itemCount: _users.length,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  itemBuilder: (context, index) => ShadowedBox(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: InkWell(
                      onTap: () => _controller.gotoProfile(_users.elementAt(index)!),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage("${Constants.IMAGE_URL}${_users.elementAt(index)?.profilePic}"),
                            radius: 50,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: TextWidget(
                              "${_users.elementAt(index)?.firstName} ${_users.elementAt(index)?.lastName}",
                              size: Get.textScaleFactor * 20.0,
                              weight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: TextWidget(
                              "@${_users.elementAt(index)?.userName}",
                              size: Get.textScaleFactor * 16.0,
                              color: AppColors.lightGrey,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      )),
    );
  }
}
