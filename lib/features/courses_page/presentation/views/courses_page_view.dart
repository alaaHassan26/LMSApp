import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_image.dart';

class CoursesPageView extends StatelessWidget {
  const CoursesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isDarkMode ? black38Color : greyColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.translate('my_coureses'),
            style: AppStyles.styleSemiBold24(context),
          ),
          centerTitle: true,
          backgroundColor: isDarkMode ? black38Color : greyColor,
        ),
        body: const CoursesPageViewListVie());
  }
}

class CoursesPageViewListVie extends StatelessWidget {
  const CoursesPageViewListVie({super.key});

  @override
  Widget build(BuildContext context) {
    List categoriesName = [
      AppLocalizations.of(context)!.translate('educational_lessons'),
      AppLocalizations.of(context)!.translate('mcq_question'),
      AppLocalizations.of(context)!.translate('download'),
    ];
    List categoriesImage = [
      'https://www.edinburghcollege.ac.uk/media/c5ghakxe/pexels-tirachard-kumtanom-733856.jpg?center=0.40242891032492345,0.50277250251192762&mode=crop&quality=80&width=1200&height=360&rnd=132717830764430000',
      'https://www.shutterstock.com/image-photo/training-courses-business-concept-stack-260nw-549736798.jpg',
      'https://cdn3.macpaw.com/images/content/save-video-iphone-Google-1200x670_1568814701.jpg'
    ];
    List categoriesOnTab = [
      AppRouter.kCourcsesBody,
      AppRouter.kMCQBody,
      AppRouter.kDownloadVideoBody,
    ];
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Card(
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: CustomItemCoursesPageViewListView(
                image: categoriesImage[index],
                courseTitle: categoriesName[index],
                onTap: () {
                  GoRouter.of(context).push(categoriesOnTab[index]);
                },
              )),
        );
      },
    );
  }
}

class CustomItemCoursesPageViewListView extends StatelessWidget {
  final String courseTitle;
  final String? courseNumber;
  final String image;
  final Function()? onTap;

  const CustomItemCoursesPageViewListView(
      {super.key,
      required this.courseTitle,
      this.courseNumber,
      this.onTap,
      required this.image});

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
              image: image),
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
