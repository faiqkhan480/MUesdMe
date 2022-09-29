import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/shadowed_box.dart';
import '../widgets/text_widget.dart';

class GeneralInfo extends StatelessWidget {
  final TextEditingController firstname;
  final TextEditingController lastname;
  final TextEditingController userName;
  final TextEditingController phone;

  const GeneralInfo({Key? key,
    required this.firstname,
    required this.lastname,
    required this.userName,
    required this.phone
  }) : super(key: key);

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
          dataRow("First name", firstname),
          const Divider(color: AppColors.grayScale, thickness: 1),
          dataRow("Last name", lastname,),
          const Divider(color: AppColors.grayScale, thickness: 1),
          dataRow("User name", userName,),
          const Divider(color: AppColors.grayScale, thickness: 1),
          dataRow("Phone number", phone,)
        ],
      ),
    );
  }

  Widget dataRow(String label, TextEditingController controller, {double? fontSize, FontWeight? weight, EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: TextWidget(label, color: AppColors.lightGrey, size: 12, weight: FontWeight.normal,)),
          Expanded(
            child: TextField(
              textAlign: TextAlign.end,
              controller: controller,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                isDense: true,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          // TextWidget(value, size: fontSize ?? 16, weight: weight ?? FontWeight.w500,),
        ],
      ),
    );
  }
}
