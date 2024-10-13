import 'package:flutter/material.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';

class CustomHeaderSetting extends StatelessWidget {
  const CustomHeaderSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        color: isDarkMode ? null : whiteColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Row(
            children: [
              const SizedBox(
                height: 80,
                width: 80,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/alaa.jpg'),
                ),
              ),
              const SizedBox(
                width: 26,
              ),
              Flexible(
                child: Text('Alaa Hassan',
                    style: AppStyles.styleSemiBold22(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
