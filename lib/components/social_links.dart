import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/assets.dart';
import '../widgets/text_widget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/shadowed_box.dart';

class SocialLinks extends StatelessWidget {

  const SocialLinks({
    Key? key,
    required this.val1,
    required this.val2,
    this.action1,
    this.action2
  }) : super(key: key);

  final bool val1;
  final bool val2;
  final ValueChanged<bool>? action1;
  final ValueChanged<bool>? action2;

  @override
  Widget build(BuildContext context) {
    return ShadowedBox(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextWidget("Connect your account", color: AppColors.primaryColor, weight: FontWeight.normal,),
          ...List.generate(3, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(index == 0 ? Assets.iconsTwitter : index == 1 ? Assets.iconsFacebook : Assets.iconsGoogle,
                      height: 20,
                    ),
                  ),
                ),
                Expanded(
                    flex: index < 2 ? 6 : 5,
                    child: TextWidget(index == 0 ?  "Twitter" : index == 1 ? "Facebook" : "Google Plus",)),
                if(index < 2)
                  Expanded(
                    child: CupertinoSwitch(
                      activeColor: AppColors.primaryColor,
                    value: index == 0 ? val1 : val2,
                      onChanged: index == 0 ? action1 : action2,
                ))
                else
                  Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => null,
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.successColor,
                                  textStyle: const TextStyle(
                                      fontFamily: Constants.fontFamily,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                      decorationThickness: 1
                                  )
                              ),
                              child: const Text("Connect"),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded)
                        ],
                      )
                  ),
              ],
            ),
          ),),
        ],
      ),
    );
  }
}
