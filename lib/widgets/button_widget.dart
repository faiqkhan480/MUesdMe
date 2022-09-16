import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musedme/utils/constants.dart';

import 'text_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    this.icon,
    this.vertical = false,
    required this.onPressed,
    this.textColor
  }) : super(key: key);

  final String text;
  final String? icon;
  final Color? textColor;
  final bool vertical;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
        textStyle: TextStyle(
          fontFamily: Constants.fontFamily,
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500
        )
      ),
      child: vertical ? Column(
        children: [
          if(icon != null)...[
            SvgPicture.asset(icon!, height: 30),
            const SizedBox(height: 5,),
          ],
          TextWidget(text,
            color: textColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ],
      ) : Row(
        children: [
          if(icon != null)...[
            SvgPicture.asset(icon!),
            const SizedBox(width: 5,),
          ],
          TextWidget(text,
            color: textColor,
            size: 12,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
