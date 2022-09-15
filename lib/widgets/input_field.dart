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
        this.readOnly = false,
        this.focusNode,
        this.onTap,
        this.onSubmit});

  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLength;
  final bool? showCounter;
  final bool readOnly;
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
      readOnly: readOnly,
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
        labelStyle: const TextStyle(fontFamily: Constants.fontFamily, color: AppColors.secondaryColor),
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

class DropDownInputField extends StatelessWidget {
  const DropDownInputField(
      {super.key,
        this.hintText,
        this.labelText,
        this.style,
        this.inputStyle,
        this.validator,
        this.isLastTextField = false,
        this.focusNode,
        required this.items,
        required this.onChanged,
        this.value,});

  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool isLastTextField;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final TextStyle? inputStyle;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 5.0, left: 15.0),
        labelText: hintText,
        labelStyle: const TextStyle(fontFamily: Constants.fontFamily, color: AppColors.secondaryColor),
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
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGrey)),
      ),
    );
  }
}