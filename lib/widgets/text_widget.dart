import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.text, {
    Key? key,
    this.color,
    this.family,
    this.size,
    this.weight,
    this.align
  }) : super(key: key);

  final String text;
  final double? size;
  final String? family;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? align;


  @override
  Widget build(BuildContext context) {
    return Text(text,
      textAlign: align,
      style: TextStyle(
      color: color ?? Colors.black,
      fontSize: size,
      fontFamily: family ?? 'Larsseit',
      fontWeight: weight ?? FontWeight.w500,
    ),
    );
  }
}

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
//   }
// }
