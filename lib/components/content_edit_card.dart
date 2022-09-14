import 'package:flutter/material.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/shadowed_box.dart';

class ContentEditCard extends StatelessWidget {
  const ContentEditCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.edit, color: AppColors.primaryColor, size: 14),
              TextWidget(" My info", color: AppColors.primaryColor, weight: FontWeight.normal,),
            ],
          ),
          const SizedBox(height: 10,),
          RichText(
              text: const TextSpan(
                style: TextStyle(fontFamily: Constants.fontFamily, color: Colors.black),
                children: [
                  TextSpan(text: "There’s nothing better drive on Golden Gate Bridge the wide strait connecting."),
                  TextSpan(text: " #Golden #Bridge", style: TextStyle(color: AppColors.primaryColor),),
                ],
              )
          ),
        ],
      ),
    );
  }
}
