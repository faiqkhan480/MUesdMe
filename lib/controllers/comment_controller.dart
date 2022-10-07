import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../services/api_service.dart';

class CommentController extends GetxController {
  final String? feedId;
  CommentController({this.feedId});

  RxList<Comment?> comments = List<Comment?>.empty(growable: true).obs;
  RxBool loading = true.obs;

  final ApiService _service = Get.find<ApiService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // debugPrint("onInit::::::: $feedId");
    getComments();
  }

  // FETCH COMMENTS DATA
  Future<void> getComments() async {
    // videos.clear();
    update();
    List res = await _service.fetchComments(feedId!);
    if(res.isNotEmpty) {
      if(comments.isEmpty) {
        comments.addAll(res as List<Comment?>);
      }
      else {
        comments.replaceRange(0, (comments.length-1), res as List<Comment?>);
      }
      update();
    }
    loading.value = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}