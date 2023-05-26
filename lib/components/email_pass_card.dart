import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/shadowed_box.dart';
import '../widgets/text_widget.dart';

class EmailPasswordCard extends StatelessWidget {
  final String? email;
  const EmailPasswordCard({Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowedBox(
      padding: EdgeInsets.zero,
      child: Container(
        color: AppColors.grayScale,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dataRow("Email address", email ?? ""),
            const Divider(color: AppColors.grayScale, thickness: 1),
            dataRow("Password", "· · · · · ·",
                fontSize: 36,
                weight: FontWeight.w800,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 8)
            ),
          ],
        ),
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
