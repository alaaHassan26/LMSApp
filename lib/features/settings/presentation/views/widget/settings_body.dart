import 'package:flutter/material.dart';

import 'package:lms/features/settings/presentation/views/widget/custom_header_setting.dart';
import 'package:lms/features/settings/presentation/views/widget/custom_item_setting.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          CustomHeaderSetting(),
          CustomItemSetting(),
        ],
      ),
    );
  }
}
