import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musedme/utils/app_colors.dart';

import '../widgets/text_widget.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.image,
    this.color,
    required this.name,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final Color? color;
  final String name;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color?.withOpacity(0.3) ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
        boxShadow: color == null ? [
          const BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 3)
          )
        ] : null
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: color ?? AppColors.lightPink,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: TextWidget(name, color: Colors.white)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 10),
                  child: TextWidget(title,),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8, bottom: 10),
                    child: TextWidget(subtitle, color: AppColors.lightGrey, size: 12,),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.all(10),
                width: 100,
                height: 100,
                child: SvgPicture.asset(image)),
          )
        ],
      ),
    );
  }
}
