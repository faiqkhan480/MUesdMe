import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.text, {
    Key? key,
    this.color,
    this.family,
    this.size,
    this.weight
  }) : super(key: key);

  final String text;
  final double? size;
  final String? family;
  final FontWeight? weight;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: color ?? Colors.black,
      fontSize: size,
      fontFamily: family ?? 'Larsseit',
      fontWeight: weight ?? FontWeight.w500,
    ),
    );
  }
}
