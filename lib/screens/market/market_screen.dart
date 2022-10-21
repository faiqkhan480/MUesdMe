import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/header.dart';
import '../../controllers/market_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_morphism.dart';
import '../../widgets/text_widget.dart';

final List<String> nfts = [
  "https://i.pinimg.com/564x/79/6c/29/796c2975ae64e163566bade45f579e9c.jpg",
  "https://i.pinimg.com/564x/5c/95/59/5c955918cb5429b97a101b94b97c3905.jpg",
  "https://i.pinimg.com/564x/76/b5/89/76b58934eddf4792be7ce37259d62bcb.jpg",
  "https://i.pinimg.com/236x/43/81/14/4381145cc8d8fec1f113aafb72877afe.jpg",
  "https://i.pinimg.com/564x/5e/59/8e/5e598e9a2181b3d81599f9e5081f4067.jpg",
  "https://i.pinimg.com/564x/06/c0/56/06c056ebc748593b2d185580d87e9f14.jpg",
  "https://i.pinimg.com/564x/6b/17/bb/6b17bbb0ea4edb7c9a8f13617e8e6f0f.jpg",
  "https://i.pinimg.com/564x/04/a8/18/04a818741f053f762f8866be83b7ffb6.jpg",
  "https://i.pinimg.com/564x/0f/ef/24/0fef2461977f02f2e931da94bc486479.jpg",
  "https://i.pinimg.com/564x/ab/55/83/ab558328dc7662da778c8370ff60f0f7.jpg",
  "https://i.pinimg.com/564x/6a/c7/2f/6ac72fb532e6b98d01eb8f5e64648905.jpg",
  "https://i.pinimg.com/564x/2e/59/c1/2e59c1876dd6b6d5852be2d3e99a65fb.jpg",
  "https://i.pinimg.com/564x/e5/88/de/e588de98a37d016b42c117caac0a00ef.jpg",
  "https://i.pinimg.com/564x/6c/48/8e/6c488e35f38e165f2225253d02d15385.jpg",
  "https://i.pinimg.com/564x/42/51/de/4251de661abe34271344e8bf674b0963.jpg",
  "https://i.pinimg.com/564x/62/cf/f2/62cff255396fd582a5ef398c95bbb4df.jpg",
];

class MarketScreen extends GetView<MarketController> {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(
            title: "Market",
            isProfile: true,
            hideButton: true,
          ),

          Flexible(child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: nfts.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemBuilder: (context, index) => InkWell(
              onTap: () => onTap(index),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(image: NetworkImage(nfts.elementAt(index)), fit: BoxFit.cover),
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget("Hype Beast", color: Colors.white, size: 22),
                    const SizedBox(height: 5,),
                    GlassMorphism(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      shape: BoxShape.rectangle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          TextWidget("Price ", color: AppColors.grayScale, weight: FontWeight.w400, size: 12),
                          TextWidget("10\$", color: Colors.white, size: 16, weight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // itemBuilder: (context, index) => CachedNetworkImage(
            //   imageUrl: nfts.elementAt(index),
            //   // progressIndicatorBuilder: (context, url, progress) => Text("${progress.downloaded}"),
            //   // progressIndicatorBuilder: (context, url, progress) => const Loader(),
            //   // errorWidget: (context, url, error) => const Icon(FontAwesome.chain_broken),
            //   imageBuilder: (context, imageProvider) => Container(
            //     color: AppColors.secondaryColor,
            //     width: double.infinity,
            //   ),
            // ),
          )),
        ],
      ),
    );
  }

  void onTap(int index ) {
   controller.setItem(nfts.elementAt(index));
  }
}
