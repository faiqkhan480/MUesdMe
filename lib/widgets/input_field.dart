import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
        this.hintText,
        this.labelText,
        this.style,
        this.inputStyle,
        this.initialValue,
        this.showCounter = false,
        this.controller,
        this.onSaved,
        this.validator,
        this.obscureText = false,
        this.isLastTextField = false,
        this.onChanged,
        this.maxLength,
        this.textAlign = TextAlign.left,
        this.inputFormatters,
        this.keyboardType,
        this.multiLine = false,
        this.enabled = true,
        this.minLines = 5,
        this.trailingIcon,
        this.onEditingComplete,
        this.focusNode,
        this.onTap,
        this.onSubmit});

  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLength;
  final bool? showCounter;
  final bool multiLine;
  final bool isLastTextField;
  final bool obscureText;
  final bool enabled;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final TextStyle? inputStyle;
  final TextEditingController? controller;
  final Function(String)? onSaved;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final TextAlign textAlign;
  final Widget? trailingIcon;
  final Function? onEditingComplete;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      enabled: enabled,
      style: inputStyle ?? const TextStyle(fontFamily: Constants.fontFamily),
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      obscureText: obscureText,
      onTap: onTap,
      initialValue: initialValue,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textAlign: textAlign,
      textInputAction:
      isLastTextField ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: onSubmit,
      // onFieldSubmitted: (_) => isLastTextField ? null : FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        labelText: hintText,
        labelStyle: const TextStyle(fontFamily: Constants.fontFamily),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.lightGrey,
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.secondaryColor,
            )
        ),
        suffixIcon: trailingIcon ?? const SizedBox(),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGrey)),
      ),
    );
  }
}