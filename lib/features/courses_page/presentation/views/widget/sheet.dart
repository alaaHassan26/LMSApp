import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.09,
      minChildSize: 0.06,
      maxChildSize: 0.26,
      builder: (context, scrollController) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  child: Icon(
                    Icons.remove,
                    size: 26,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(AppRouter.kMCQBody);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          GoRouter.of(context)
                                              .push(AppRouter.kMCQBody);
                                        },
                                        icon: const Icon(
                                            Iconsax.message_question)),
                                    Text(
                                      'MCQ',
                                      style: AppStyles.styleMedium20(context),
                                    ),
                                    const Spacer(),
                                    Icon(isArabic(context)
                                        ? Iconsax.arrow_circle_left
                                        : Iconsax.arrow_circle_right),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Iconsax.video_circle)),
                                  Text(
                                    'التنزيلات',
                                    style: AppStyles.styleMedium20(context),
                                  ),
                                  const Spacer(),
                                  Icon(isArabic(context)
                                      ? Iconsax.arrow_circle_left
                                      : Iconsax.arrow_circle_right),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
