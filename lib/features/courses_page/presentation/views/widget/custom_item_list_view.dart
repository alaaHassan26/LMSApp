import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/Constatns.dart';

import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';

class CustomItemListView extends StatelessWidget {
  final String courseTitle;
  final String? courseNumber;
  final String? image;
  final Function()? onTap;

  const CustomItemListView(
      {super.key, required this.courseTitle, this.courseNumber, this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomImage(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            image:
              '${CS.Api}$image',
          ),
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
