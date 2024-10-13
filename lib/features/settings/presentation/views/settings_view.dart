import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/settings/presentation/views/widget/settings_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor2,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? black38Color : greyColor2,
        title: Text(
          AppLocalizations.of(context)!.translate('settings'),
          style: AppStyles.styleSemiBold24(context),
        ),
      ),
      body: const SettingsBody(),
    );
  }
}
