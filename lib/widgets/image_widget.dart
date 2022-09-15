import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/utils/app_colors.dart';

import '../utils/assets.dart';
import '../utils/constants.dart';

class ImageWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? borderRadius;
  const ImageWidget({Key? key, required this.url, this.height, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: Image.network(
          url,
          loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : Lottie.asset(Assets.loader),
          // errorBuilder: (context, error, stackTrace) => Icon(Icons.photo, color: AppColors.secondaryColor.withOpacity(0.4),),
          height: height,
          fit: BoxFit.cover,
        ));
  }
}
