import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musedme/utils/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return const TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(),
      ),
    );
  }
}
