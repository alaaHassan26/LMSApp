import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';

class CustomPinnedPost extends StatelessWidget {
  const CustomPinnedPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CustomImage(
          image: 'assets/images/rebot.jpg',
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
        ),
        title: SizedBox(
          child: Text(AppLocalizations.of(context)!.translate('mobile'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.styleSemiBold18(context)),
        ),
        trailing: const Icon(Iconsax.close_square),
      ),
    );
  }
}
