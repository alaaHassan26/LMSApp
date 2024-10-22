import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/Server/Api_Dio.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/views/courses_page_view.dart';
import 'package:lms/features/home/data/data_sources/home_local_data_source.dart';
import 'package:lms/features/home/data/data_sources/home_remot_data_source.dart';
import 'package:lms/features/home/data/repos_impl/home_repo_impl.dart';
import 'package:lms/features/home/domain/use_cases/news_use_case.dart';
import 'package:lms/features/home/presentation/manger/facth_news_cubit/facth_news_cubit.dart';
import 'package:lms/features/home/presentation/views/home_view.dart';
import 'package:lms/features/settings/presentation/views/settings_view.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final bool _isAtTop = true;

  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => FacthNewsCubit(
          FetchNewsetUseCase(HomeRepoImpl(
            homeRemotDataSource:
                HomeRemotDataSourceImpl(apiService: ApiService()),
          )),
          HomelocalDataSourceImpl()),
      child: const HomeView(),
    ),
    const CoursesPageView(),
    const SettingsView(),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
              labelTextStyle:
                  WidgetStateProperty.all(AppStyles.styleMedium16(context)))),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          backgroundColor: isDarkMode ? black38Color : greyColor2,
          height: 80,
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: const Icon(Iconsax.home),
              label: AppLocalizations.of(context)!.translate('home1'),
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.video4),
              label: AppLocalizations.of(context)!.translate('courses'),
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.setting),
              label: AppLocalizations.of(context)!.translate('settings'),
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
    );
  }
}
