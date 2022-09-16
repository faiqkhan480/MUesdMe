import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/assets.dart';

class SearchField extends StatelessWidget {
  final Color? iconColor;
  final String? placeHolder;
  const SearchField({Key? key, this.iconColor, this.placeHolder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 2,
              blurRadius: 4
          )]
      ),
      child: TextField(
        // obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          // prefixIconConstraints: BoxConstraints(minHeight: 20),
          prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
            child: SvgPicture.asset(Assets.iconsSearch, color: iconColor ?? AppColors.primaryColor, ),
          ),
          hintText: placeHolder ?? 'Search',
          hintStyle: const TextStyle(color: AppColors.secondaryColor),
          isDense: true,
          // fillColor: Colors.white,
          // filled: true,
          // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white)),
        ),
      ),
    );
    return Material(
      elevation: 5.0,
      shadowColor: AppColors.shadowColor.withOpacity(.3),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: TextField(
        // obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.primaryColor),
            hintText: 'Search',
            isDense: true,
            // fillColor: Colors.white,
            // filled: true,
            // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
