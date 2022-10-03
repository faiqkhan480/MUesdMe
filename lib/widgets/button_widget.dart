import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musedme/utils/constants.dart';

import '../utils/app_colors.dart';
import 'text_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    this.icon,
    this.vertical = false,
    required this.onPressed,
    this.textColor,
    this.bgColor,
    this.loader = false,
  }) : super(key: key);

  final String text;
  final String? icon;
  final Color? textColor;
  final Color? bgColor;
  final bool vertical;
  final bool loader;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          backgroundColor: bgColor ?? Colors.transparent,
        textStyle: TextStyle(
          fontFamily: Constants.fontFamily,
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500
        )
      ),
      child: vertical ?
      Column(
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
      ) :
      loader ?
      const SizedBox (
          height: 20,
          width: 20,
          child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5,))) :
      Row(
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

class SmallButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final Widget? icon;
  final String title;
  const SmallButton({Key? key, required this.title, this.onPressed, this.icon, this.color = AppColors.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: const TextStyle(fontSize: 12,
              color: Colors.white,
              fontFamily: Constants.fontFamily)
      ),
      child: icon != null ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon!,
          const SizedBox(width: 5,),
          Text(title),
        ],
      ) :
      Text(title),
    );
  }
}

