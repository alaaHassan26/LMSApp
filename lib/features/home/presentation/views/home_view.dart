import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/home/presentation/views/widget/home_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? null : whiteColor,
        title: Text(
          AppLocalizations.of(context)!.translate('news'),
          style: AppStyles.styleSemiBold34(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.notification),
          ),
        ],
      ),
      body: const SafeArea(
        child: HomeBody(),
      ),
    );
  }
}
