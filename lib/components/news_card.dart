import 'package:flutter/material.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/glass_morphism.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Colors.green,
        image: DecorationImage(image: NetworkImage(Constants.greenVector), fit: BoxFit.cover)
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: GlassMorphism(
              child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),),
          ),

          const Spacer(),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(6)
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const TextWidget("Local", size: 12, color: Colors.white, weight: FontWeight.normal)),
          ),
          const SizedBox(height: 5,),
          const Flexible(child: TextWidget("Sightsee the locals, landlubbers abound", size: 18, color: Colors.white, weight: FontWeight.normal)),
          const SizedBox(height: 10,),
          Row(
            children: const [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  backgroundImage: NetworkImage(Constants.albumArt)),
              SizedBox(width: 5,),
              TextWidget("Anne Bonny", size: 12, color: Colors.white, weight: FontWeight.w500),
            ],
          )
        ],
      ),
    );
  }
}
