import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/views/courses_page_view.dart';
import 'package:lms/features/home/presentation/views/home_view.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final bool _isAtTop = true;

  final List<Widget> _screens = [
    const HomeView(),
    const CoursesPageView(),
    const SizedBox(),
    const SizedBox(),
  ];

  void initScreens() {
    _screens.addAll([]);
  }

  @override
  void initState() {
    super.initState();
    initScreens();

    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_selectedIndex == 0) {
      if (_isAtTop) {
        return false;
      } else {
        return true;
      }
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _selectedIndex = 0;
        });
      }
      return true;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home),
            label: AppLocalizations.of(context)!.translate('home1'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.video_octagon),
            label: AppLocalizations.of(context)!.translate('courses'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.heart),
            label: 'page 3',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.personalcard),
            label: 'page 4',
          ),
        ],
        unselectedItemColor: greyColor,
        selectedLabelStyle: AppStyles.styleBold16(context),
        unselectedLabelStyle: AppStyles.styleMedium16(context),
        showUnselectedLabels: true,
      ),
      body: _screens[_selectedIndex],
    );
  }
}
