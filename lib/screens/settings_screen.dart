import 'package:flutter/material.dart';
import 'package:musedme/widgets/text_widget.dart';

import '../components/custom_header.dart';
import '../utils/app_colors.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _options = ["Themes", "About", "Privacy", "Security", "Help"];

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
                    onTap: () => null,
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