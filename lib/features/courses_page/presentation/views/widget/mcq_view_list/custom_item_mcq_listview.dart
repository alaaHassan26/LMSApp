import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';

import 'package:lms/core/utils/appstyles.dart';

class CustomItemMcqListView extends StatelessWidget {
  final String courseTitle;
  final String? courseNumber;
  final Function()? onTap;

  const CustomItemMcqListView(
      {super.key, required this.courseTitle, this.courseNumber, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              courseTitle,
              style: AppStyles.styleSemiBold20(context),
            ),
            subtitle: Text(
              courseNumber ?? '',
              style: AppStyles.styleMedium16(context),
            ),
            trailing: IconButton(
              onPressed: onTap,
              icon: Icon(isArabic(context)
                  ? Iconsax.arrow_circle_left
                  : Iconsax.arrow_circle_right),
            ),
          )
        ],
      ),
    );
  }
}
