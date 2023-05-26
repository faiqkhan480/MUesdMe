import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/assets.dart';
import 'loader.dart';

class ImageWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final double? borderRadius;
  const ImageWidget({Key? key, required this.url, this.height, this.borderRadius, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: Image.network(
          url,
          loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
          errorBuilder: (context, error, stackTrace) => Icon(Icons.photo, color: AppColors.secondaryColor.withOpacity(0.4), size: ((height ?? 0) - 30)),
          height: height,
          width: width,
          fit: BoxFit.cover,
          // color: Colors.white,
        ));
  }
}
