import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';

class CustomItemListView extends StatelessWidget {
  const CustomItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImage(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            image: 'assets/images/rebot.jpg'),
        const SizedBox(
          height: 8,
        ),
        ListTile(
            title: Text(
              AppLocalizations.of(context)!.translate('cours_title'),
              style: AppStyles.styleSemiBold20(context),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.translate('cours_num'),
              style: AppStyles.styleMedium16(context),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(isArabic(context)
                  ? Iconsax.arrow_circle_left
                  : Iconsax.arrow_circle_right),
            ))
      ],
    );
  }
}
