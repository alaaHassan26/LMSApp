import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/home/presentation/views/widget/home_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSelectionMode = false;

  void _enterSelectionMode() {
    setState(() {
      isSelectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Add logic for sharing the post
                    _exitSelectionMode();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.push_pin),
                  onPressed: () {
                    // Add logic for pinning the post
                    _exitSelectionMode();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // Add logic for copying the post text
                    _exitSelectionMode();
                  },
                ),
              ],
            )
          : AppBar(
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
      body: SafeArea(
        child: HomeBody(
          onLongPressPost: _enterSelectionMode,
        ),
      ),
    );
  }
}
