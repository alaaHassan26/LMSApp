import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/appstyles.dart';

class CustomListTitleSetting extends StatelessWidget {
  const CustomListTitleSetting({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final Function()? onPressed;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: AppStyles.styleMedium20(context),
        ),
        trailing: trailing ??
            IconButton(
              onPressed: onPressed,
              icon: Icon(isArabic(context)
                  ? Iconsax.arrow_circle_left
                  : Iconsax.arrow_circle_right),
            ));
  }
}
