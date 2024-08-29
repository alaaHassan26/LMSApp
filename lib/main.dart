import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/manger/app_lang_cubit/app_lang_cubit.dart';
import 'package:lms/core/models/Enums/lang_event_type.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLangCubit()..appLang(LangEventEnums.initialLang),
      child: BlocBuilder<AppLangCubit, AppLangState>(
        builder: (context, state) {
          if (state is AppChangeLang) {
            return MaterialApp.router(
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xff27DEBF),
                    brightness: Brightness.dark),
                useMaterial3: true,
              ),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xff27DEBF),
                    brightness: Brightness.light),
                useMaterial3: true,
              ),
              locale: Locale(state.languageCode!),
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
          }
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xff27DEBF),
                  brightness: Brightness.dark),
              useMaterial3: true,
            ),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xff27DEBF),
                  brightness: Brightness.light),
              useMaterial3: true,
            ),
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
      ),
    );
  }
}
