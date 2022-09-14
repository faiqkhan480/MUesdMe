import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final double? horizontalSpacing;
  const TitleRow({Key? key, required this.title, this.horizontalSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: horizontalSpacing ?? 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(title, size: 17, color: AppColors.primaryColor),
          TextButton(
            onPressed: () => null,
            style: TextButton.styleFrom(
                foregroundColor: AppColors.lightGrey,
                textStyle: const TextStyle(
                    fontFamily: Constants.fontFamily,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    decorationThickness: 2
                )
            ),
            child: const Text("Show all"),
          ),
        ],
      ),
    );
  }
}
