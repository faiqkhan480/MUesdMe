import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  const MessageInput(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () => null,
          color: AppColors.lightGrey,
            iconSize: 30,
            icon: const Icon(Icons.image_rounded,)
        ),
        hintText: 'Type a message....',
        hintStyle: const TextStyle(color: AppColors.lightGrey),
        // isDense: true,
        fillColor: AppColors.textFieldColor,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.white)),
      ),
    );
  }
}
