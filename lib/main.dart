import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/manger/app_lang_cubit/app_lang_cubit.dart';
import 'package:lms/core/manger/app_lang_cubit/app_theme_cubit/app_theme_cubit.dart';
import 'package:lms/core/models/Enums/lang_event_type.dart';
import 'package:lms/core/models/Enums/theme_state.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/auth/presentation/manger/auth_cubit/auth_cubit.dart';

import 'core/Server/Bloc_Observer.dart';
import 'features/courses_page/presentation/manger/course_cubit/course_cubit.dart';
import 'features/courses_page/presentation/manger/mcq_cubit/mcq_cubit.dart';
import 'features/home/presentation/manger/news_comment_cubit/news_comment_cubit.dart';
import 'features/home/presentation/manger/news_cubit/news_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await CacheHelper().init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => LoginCubit()),
      BlocProvider(create: (context) => CommentsCubit()),
      BlocProvider(create: (context) => McqCubit()),
      BlocProvider(create: (context) => NewsCubit()),
      BlocProvider(create: (context) => CoursesCubit()),

      

      
      BlocProvider(
          create: (context) =>
              AppThemeCubit()..changeTheme(ThemeState.initial)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLangCubit()..appLang(LangEventEnums.initialLang),
      child: BlocBuilder<AppLangCubit, AppLangState>(
        builder: (context, state) {
          return BlocBuilder<AppThemeCubit, AppThemeState>(
            builder: (context, themeState) {
              ThemeData lightTheme = ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              );

              ThemeData darkTheme = ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              );

              return MaterialApp.router(
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeState is AppDarkTheme
                    ? ThemeMode.dark
                    : ThemeMode.light,
                locale:
                    state is AppChangeLang ? Locale(state.languageCode!) : null,
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                localeResolutionCallback: (deviceLocal, supportedLocales) {
                  for (var local in supportedLocales) {
                    if (deviceLocal != null) {
                      if (deviceLocal.languageCode == local.languageCode) {
                        return deviceLocal;
                      }
                    }
                  }
                  return supportedLocales.first;
                },
              );
            },
          );
        },
      ),
    );
  }
}
