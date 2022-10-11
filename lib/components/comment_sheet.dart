import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/comment_controller.dart';
import '../models/comment.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/loader.dart';
import '../widgets/text_widget.dart';

class CommentSheet extends GetWidget<CommentController> {
  const CommentSheet({Key? key}) : super(key: key);

  List<Comment?> get _comments => controller.comments;
  bool get _loading => controller.loading();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear)),
                const Spacer(flex: 2,),
                const Text("Comments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Larsseit',
                  fontWeight: FontWeight.w500,
                ),),

                // const SizedBox.shrink(),
                const Spacer(flex: 3,),
              ],
            ),
            Obx(() =>
            Flexible(
                child: (_loading) ?
                const Loader() :
                ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, index) =>
                    Row(
                      children: [
                        _imageView(_comments.elementAt(index)?.profilePic),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F1FE),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                  _comments.elementAt(index)?.fullName ?? "",
                                  weight: FontWeight.w800,
                                ),
                                    TextWidget(
                                  _comments.elementAt(index)?.comment ?? "",
                                  // weight: FontWeight.bold,
                                  size: 16.0,
                                ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    itemCount: _comments.length
                )),
            ),
            const SizedBox(height: 20),

            Obx(() => TextFormField(
              controller: controller.comment,
              decoration: InputDecoration(
                hintText: "Type a comment...",
                suffixIcon: controller.fetching() ?
                const SizedBox(
                    height: 2,
                    width: 2,
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 2,))) :
                IconButton(
                  icon: Icon(Icons.send,color: Theme.of(context).primaryColor,),
                  onPressed: controller.postComment,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            )),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _removable(Widget child) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // setState(() {
            //   image = null;
            //   // widget?.onImageRemoved();
            // });
          },
        )
      ],
    );
  }

  Widget _imageView([String? url]) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.network(
        url != null && url.isNotEmpty ? "${Constants.IMAGE_URL}$url" : Constants.dummyImage,
        fit: BoxFit.cover,
        height: 50,
        width: 50,
      ),
    );
  }
}