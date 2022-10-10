import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ShadowedBox extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;
  final bool shadow;
  const ShadowedBox({Key? key, this.padding, required this.child, this.shadow = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: shadow ? const [BoxShadow(
              color: AppColors.grayScale, // AppColors.shadow,
              blurRadius: 4
          )] : null
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }
}
