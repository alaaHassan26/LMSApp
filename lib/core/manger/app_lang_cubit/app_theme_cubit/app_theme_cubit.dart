import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/models/Enums/theme_state.dart';

import 'package:flutter/material.dart';
part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeInitial());

  changeTheme(ThemeState state) async {
    switch (state) {
      case ThemeState.initial:
        final theme = await CacheHelper().getData(key: 'theme');
        if (theme != null) {
          if (theme == 'l') {
            emit(AppLightTheme());
          } else {
            emit(AppDarkTheme());
          }
        } else {
          // ignore: deprecated_member_use
          var brightness = WidgetsBinding.instance.window.platformBrightness;
          if (brightness == Brightness.dark) {
            CacheHelper().saveData(key: 'theme', value: 'd');
            emit(AppDarkTheme());
          } else {
            CacheHelper().saveData(key: 'theme', value: 'l');
            emit(AppLightTheme());
          }
        }
        break;
      case ThemeState.ligth:
        CacheHelper().saveData(key: 'theme', value: 'l');
        emit(AppLightTheme());
        break;
      case ThemeState.dark:
        CacheHelper().saveData(key: 'theme', value: 'd');
        emit(AppDarkTheme());
        break;
      default:
    }
  }
}
