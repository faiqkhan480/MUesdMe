import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_header.dart';
import '../controllers/settings_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/text_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  SettingsController get _controller => Get.put<SettingsController>(SettingsController());

  @override
  Widget build(BuildContext context) {
    final List<String> _options = ["About", "Privacy", "Security", "Help", "Logout"];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomHeader(title: "Setting",
                buttonColor: AppColors.primaryColor,
                showBottom: false,
                showSearch: false,
                showSave: false,
                showRecentWatches: false,
            ),

            Flexible(child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(_options.length, (index) => Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.grayScale))
                  ),
                  child: ListTile(
                    onTap: () => index == (_options.length-1) ? _controller.handleLogout() : null,
                    title: TextWidget(_options.elementAt(index)),
                  ),
                )),
              ),
            )),
          ],
        ),
      ),
    );
  }
}