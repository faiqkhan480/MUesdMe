import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final String? feedId;
  CommentController({this.feedId});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    debugPrint("onInit::::::: $feedId");
  }
}