// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/models/Enums/lang_event_type.dart';

part 'app_lang_state.dart';

class AppLangCubit extends Cubit<AppLangState> {
  AppLangCubit() : super(AppLangInitial());

  appLang(LangEventEnums eventType) async {
    switch (eventType) {
      case LangEventEnums.initialLang:
        final cachedLang = CacheHelper().getDataString(key: 'lang');
        if (cachedLang != null) {
          emit(AppChangeLang(languageCode: cachedLang));
        } else {
          final deviceLang = window.locale.languageCode;
          if (deviceLang == 'ar') {
            await _changeLanguage('ar');
          } else {
            await _changeLanguage('en');
          }
        }
        break;
      case LangEventEnums.arabicLang:
        await _changeLanguage('ar');
        break;
      case LangEventEnums.englishLang:
        await _changeLanguage('en');
        break;
      default:
    }
  }

  Future<void> _changeLanguage(String lang) async {
    await CacheHelper().saveData(key: 'lang', value: lang);
    await _clearProductCache();
    emit(AppChangeLang(languageCode: lang));
  }

  Future<void> _clearProductCache() async {
    await CacheHelper().removeData(key: 'products_new');
    await CacheHelper().removeData(key: 'products_clothes');
    await CacheHelper().removeData(key: 'products_electronics');
    await CacheHelper().removeData(key: 'products_medical');
    await CacheHelper().removeData(key: 'products_sports');
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shoping/cache/cache_helper.dart';
// import 'package:shoping/core/models/Enums/lang_event_type.dart';

// part 'app_lang_state.dart';

// class AppLangCubit extends Cubit<AppLangState> {
//   AppLangCubit() : super(AppLangInitial());

//   appLang(LangEventEnums eventType) async {
//     switch (eventType) {
//       case LangEventEnums.initialLang:
//         if (CacheHelper().getDataString(key: 'lang') != null) {
//           if (CacheHelper().getDataString(key: 'lang') == 'ar') {
//             emit(AppChangeLang(languageCode: 'ar'));
//           } else {
//             emit(AppChangeLang(languageCode: 'en'));
//           }
//         }
//         break;
//       case LangEventEnums.arabicLang:
//         await _changeLanguage('ar');
//         break;
//       case LangEventEnums.englishLang:
//         await _changeLanguage('en');
//         break;
//       default:
//     }
//   }

//   Future<void> _changeLanguage(String lang) async {
//     await CacheHelper().saveData(key: 'lang', value: lang);
//     await _clearProductCache();
//     emit(AppChangeLang(languageCode: lang));
//   }

//   Future<void> _clearProductCache() async {
//     await CacheHelper().removeData(key: 'products_new');
//     await CacheHelper().removeData(key: 'products_clothes');
//     await CacheHelper().removeData(key: 'products_electronics');
//     await CacheHelper().removeData(key: 'products_medical');
//     await CacheHelper().removeData(key: 'products_sports');
//   }
// }
