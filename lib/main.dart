import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';
import 'package:lms/core/manger/app_lang_cubit/app_lang_cubit.dart';
import 'package:lms/core/manger/app_lang_cubit/app_theme_cubit/app_theme_cubit.dart';

import 'package:lms/core/models/Enums/lang_event_type.dart';
import 'package:lms/core/models/Enums/theme_state.dart';

import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/colors.dart';

import 'package:lms/features/home/data/data_sources/home_remot_data_source.dart';
import 'package:lms/features/home/data/repos_impl/home_repo_impl.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/enitites/news_image.dart';
import 'package:lms/features/home/domain/use_cases/news_use_case.dart';
import 'package:lms/features/home/presentation/manger/facth_news_cubit/facth_news_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'core/Server/Bloc_Observer.dart';

import 'features/home/presentation/manger/CommentManger/add&replay_comment/add_comment_cubit.dart';
import 'features/home/presentation/manger/CommentManger/edit_comment/edit_comment_cubit.dart';

import 'features/home/presentation/manger/CommentManger/delete_comment&replay/delete_comment_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = storage;
  Bloc.observer = SimpleBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(NewsEnityAdapter());
  Hive.registerAdapter(NewsImageAdapter());
  await Hive.openBox<NewsEnity>('newsCache');
  await Hive.openBox('settings');
  await CacheHelper().init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) => FacthNewsCubit(
                FetchNewsetUseCase(HomeRepoImpl(
                  homeRemotDataSource:
                      HomeRemotDataSourceImpl(apiService: ApiService()),
                )),
              )),
      BlocProvider(create: (context) => AddCommentCubit()),
      BlocProvider(create: (context) => DeleteCommentCubit()),
      BlocProvider(create: (context) => EditCommentCubit()),
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
