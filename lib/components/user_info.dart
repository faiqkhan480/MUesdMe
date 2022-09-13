import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/shadowed_box.dart';
import '../widgets/text_widget.dart';

class GeneralInfo extends StatelessWidget {
  const GeneralInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowedBox(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextWidget("General info", color: AppColors.primaryColor, weight: FontWeight.normal,),
          ),
          const SizedBox(height: 10,),
          dataRow("First name", "James"),
          const Divider(color: AppColors.grayScale, thickness: 1),
          dataRow("Last name", "Martinia Junior",),
          const Divider(color: AppColors.grayScale, thickness: 1),
          dataRow("Phone number", "",)
        ],
      ),
    );
  }

  Widget dataRow(String label, String value, {double? fontSize, FontWeight? weight, EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(label, color: AppColors.lightGrey, size: 12, weight: FontWeight.normal,),
          TextWidget(value, size: fontSize ?? 16, weight: weight ?? FontWeight.w500,),
        ],
      ),
    );
  }
}
