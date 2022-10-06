import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/comment_controller.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class CommentSheet extends GetWidget<CommentController> {
  const CommentSheet({Key? key}) : super(key: key);

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
            Expanded(child: ListView.builder(
                itemBuilder: (context, index) => Row(
                  children: [
                    _imageView(),

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
                              children: const  [
                                TextWidget(
                                  "profileName",
                                  weight: FontWeight.w800,
                                ),
                                TextWidget(
                                  "postComment",
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
                // separatorBuilder: separatorBuilder,
                itemCount: 2
            )),
            const SizedBox(height: 20),

            TextFormField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.send,color: Theme.of(context).primaryColor,),
                  onPressed: () => null,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),

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

  Widget _imageView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          Constants.dummyImage,
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}