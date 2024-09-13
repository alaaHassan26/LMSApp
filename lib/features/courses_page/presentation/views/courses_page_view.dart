import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/views/widget/sheet.dart';
import 'package:lms/features/courses_page/presentation/views/widget/courses_view_list/courses_body.dart';

class CoursesPageView extends StatelessWidget {
  const CoursesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor.shade300,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.translate('my_coureses'),
          style: AppStyles.styleSemiBold24(context),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? black38Color : greyColor.shade300,
      ),
      body: const Stack(
        children: [
          CourcsesBody(),
          CustomBottom(),
        ],
      ),
    );
  }
}
