import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../services/api_service.dart';

class CommentController extends GetxController {
  final String? feedId;
  CommentController({this.feedId});

  RxList<Comment?> comments = List<Comment?>.empty(growable: true).obs;
  RxBool loading = true.obs;
  RxBool fetching = false.obs;

  TextEditingController comment = TextEditingController();

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

  Future<void> postComment() async {
    comment.text.trim();
    if(comment.text.isNotEmpty) {
      fetching.value = true;
      List res = await _service.postComments(feedId!, comment.text);
      if(res.isNotEmpty) {
        comment.clear();
        if(comments.isNotEmpty) {
          debugPrint(":::::::::::");
          comments.clear();
          comments.addAll(res as List<Comment?>);
        }
        else {
          comments.addAll(res as List<Comment?>);
        }
        update();
      }
      fetching.value = false;
    }
  }
}