
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:musedme/controllers/feed_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';

import '../components/custom_header.dart';
import '../controllers/profile_controller.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';

class UploadScreen extends StatefulWidget {
  final PhotoEditorResult post;
  const UploadScreen({Key? key,required this.post}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool loading = false;
  String get img => widget.post.image.substring(7);
  String value = "Public";

  final ApiService _service = Get.find<ApiService>();
  final FeedController _feeds = Get.find<FeedController>();
  final ProfileController _profile = Get.find<ProfileController>();

  getFile() async {
    debugPrint(":::::::::::: ${widget.post.toJson()}");
    final root = await getApplicationDocumentsDirectory();
    final path = "$root/${widget.post.image}";
    File? f = await File(path).create(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // HEADER
            const CustomHeader(
                title: "Upload Feed",
                buttonColor: AppColors.primaryColor,
                showBottom: false,
                showSave: false
            ),
            Flexible(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(
                      // file:///data/user/0/com.gesolucions.musedme/cache/imgly_5123618383305505258.png
                      File(img),
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),

                  DropdownButtonHideUnderline(child: DropdownButton(
                        items: ["Public", "Friends", "Only me"].map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.black),
                          ),
                        )).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        onChanged: (d) async {
                          setState(() {
                            value = d!;
                          });
                        },
                        value: value,
                      )),

                  const Spacer(),
                  if(loading)
                    const SizedBox(
                        height: 55,
                        child: Center(child: Loader(),))
                  else
                  TextButton(
                    onPressed: uploadFeed,
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                        textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Feather.upload, color: Colors.white),
                        // SvgPicture.asset(Assets.iconsDelete),
                        SizedBox(width: 5,),
                        Text("Upload"),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  uploadFeed() async {

    setState(() {
      loading = true;
    });
    // String feedPath, String type, String privacy
    String? filePath = await _service.uploadFeedFile(File(img).path);
    if(filePath != null) {
      var res = await _service.uploadFeed(filePath, "Image", value);
      if(res == true) {
        await _feeds.getFeeds();
        await _profile.getData();
        Get.close(2);
      }
    }
    setState(() {
      loading = false;
    });
  }
}
