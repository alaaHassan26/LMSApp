import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_image.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? null : greyColor.shade300,
      appBar: AppBar(
        backgroundColor: isDarkMode ? null : greyColor.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'MCQ Quiz',
                  style: AppStyles.styleSemiBold24(context),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 6,
                    color: isDarkMode ? null : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CustomImage(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .25,
                              image:
                                  'https://www.shutterstock.com/image-photo/training-courses-business-concept-stack-260nw-549736798.jpg'),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 6),
                            child: Divider(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'هنا وضع اسم المادة',
                            style: AppStyles.styleMedium24(context),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 120, vertical: 6),
                            child: Divider(),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      Card(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(isArabic(context)
                                    ? Iconsax.arrow_circle_right
                                    : Iconsax.arrow_circle_left),
                                TextButton(
                                    onPressed: () {
                                      GoRouter.of(context)
                                          .push(AppRouter.kMCQBody);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('another_quiz'),
                                        style:
                                            AppStyles.styleMedium20(context))),
                              ],
                            ),
                          )),
                      const Spacer(),
                      Card(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      GoRouter.of(context)
                                          .go(AppRouter.kNavigationMenu);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('end_and_back'),
                                        style:
                                            AppStyles.styleMedium20(context))),
                                Icon(isArabic(context)
                                    ? Iconsax.arrow_circle_left
                                    : Iconsax.arrow_circle_right),
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
