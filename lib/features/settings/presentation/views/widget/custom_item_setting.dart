import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/theme_toggle_button.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_dropdown_lang.dart';
import 'package:lms/features/settings/presentation/views/widget/custom_list_title_setting.dart';

class CustomItemSetting extends StatelessWidget {
  const CustomItemSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          child: Card(
            color: isDarkMode ? null : whiteColor,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kUserUpdateView);
                  },
                  child: CustomListTitleSetting(
                    icon: Iconsax.profile_circle,
                    title: AppLocalizations.of(context)!.translate('m_profile'),
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kUserUpdateView);
                    },
                  ),
                ),
                CustomListTitleSetting(
                  icon: Icons.language,
                  title: AppLocalizations.of(context)!.translate('lang'),
                  trailing: const LanguageSelector(),
                ),
                CustomListTitleSetting(
                  icon: Icons.dark_mode,
                  title: AppLocalizations.of(context)!.translate('darkmode'),
                  trailing: const ThemeToggleButton(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          child: Card(
            color: isDarkMode ? null : whiteColor,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: CustomListTitleSetting(
              icon: Iconsax.message_question,
              title: AppLocalizations.of(context)!.translate('about'),
              onPressed: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          child: Card(
            color: isDarkMode ? null : whiteColor,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: CustomListTitleSetting(
              icon: Icons.report,
              title: AppLocalizations.of(context)!.translate('report'),
              onPressed: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          child: Card(
            color: isDarkMode ? null : whiteColor,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('account'),
                        style: AppStyles.styleMedium20(context),
                      ),
                    ],
                  ),
                ),
                CustomListTitleSetting(
                  icon: Iconsax.logout,
                  title: AppLocalizations.of(context)!.translate('sinout'),
                  onPressed: () {
                    context.go(AppRouter.kLogIn);
                  },
                ),
                CustomListTitleSetting(
                  icon: Icons.repeat,
                  title: 'alaahassan@lim,com',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
