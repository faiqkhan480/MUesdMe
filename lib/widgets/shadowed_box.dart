import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ShadowedBox extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;
  const ShadowedBox({Key? key, this.padding, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(
              color: AppColors.grayScale, // AppColors.shadow,
              blurRadius: 4
          )]
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }
}
